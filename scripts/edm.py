"""
@brief     
@details   
@author    Mathew Cosgrove
@date      Tuesday December 5th 2023
@file      rinex-downloader.py
@copyright (c) 2023 NORTHROP GRUMMAN CORPORATION
-----
Last Modified: 11/10/2024 07:00:02
Modified By: Mathew Cosgrove
-----
"""

from http.cookiejar import CookieJar
from urllib.parse import urlencode
import urllib
from datetime import datetime

import requests 


def get_day_number(date: datetime):
    """Get the day number of the year from a date."""
    return date.timetuple().tm_yday

def get_year_doy(date=datetime.now()):
    """Get the year and day number of the year from a date."""
    return date.year, get_day_number(date)

def get_cors_station_list():
    """Get the CORS station list."""
    # The CORS station list is a list of Continuously Operating Reference Stations (CORS) that are
    # used to provide high-accuracy positioning data for a variety of applications, including surveying,
    # mapping, and geodesy. These stations are equipped with Global Navigation Satellite System (GNSS)
    # receivers that track signals from multiple satellite constellations, such as GPS, GLONASS, Galileo,
    # and BeiDou, to determine precise position information. The CORS station list contains information
    # about the location, identifier, and other details of each CORS station, which can be used to access
    # data from these stations for various applications.
    

# https://cddis.nasa.gov/archive/gnss/data/daily/2023/339/23n/
# Function to assemble RINEX URL
def get_rinex_url(year, doy, file_type="GPS", frequency="daily", version="V2"):
    """
    Generate the URL for downloading RINEX files from the CDDIS archive.

    Parameters:
    year (int): The year for which the RINEX file is needed.
    doy (int): The day of the year (1-365/366) for which the RINEX file is needed.
    file_type (str, optional): The type of RINEX file. Default is "GPS".
    frequency (str, optional): The frequency of the data. Can be "daily" or "hourly". Default is "daily".
    version (str, optional): The version of the RINEX file. Default is "V2".

    Returns:
    str: The URL to download the specified RINEX file.

    Example:
    >>> get_rinex_url(2023, 150)
    'https://cddis.nasa.gov/archive/gnss/data/daily/2023/150/23n/brdc1500.23n.gz'
    """
    base_url = "https://cddis.nasa.gov/archive/gnss/data/"
    if frequency == "daily":
        base_url += "daily/"
    elif frequency == "hourly":
        base_url += "hourly/"

    yy = str(year)[-2:]
    # The `file_extension` variable in the `get_rinex_url` function is used to store the file
    # extension that will be appended to the file name based on the file type and version. In this
    # case, the file extension is set to ".gz", which typically indicates that the file is compressed
    # using gzip compression. This extension is commonly used for compressed files to reduce file size
    # and facilitate faster downloads.
    file_extension = ".gz"

    if version == "V2":
        if file_type == "GPS":
            file_name = f"brdc{doy}0.{yy}n{file_extension}"
        elif file_type == "GLONASS":
            file_name = f"brdc{doy}0.{yy}g{file_extension}"
    # Add other conditions for different versions and file types

    url = f"{base_url}{year}/{doy}/{yy}n/{file_name}"
    return url

# https://cddis.nasa.gov/archive/gnss/data/daily/2023/339/23339.status
# IGS Tracking Network Status for DOY 339
def get_status_url(year, doy):
    """
    Generate the URL for downloading the IGS tracking network status file for a given day of the year.

    Parameters:
    year (int): The year for which the tracking network status file is needed.
    doy (int): The day of the year (1-365/366) for which the tracking network status file is needed.

    Returns:
    str: The URL to download the tracking network status file for the specified day of the year.

    Example:
    >>> get_status_url(2023, 150)
    'https://cddis.nasa.gov/archive/gnss/data/daily/2023/150/23339.status'
    """
    base_url = "https://cddis.nasa.gov/archive/gnss/data/daily/"
    url = f"{base_url}{year}/{doy}/{year}{doy}.status"
    return url

# get the requsts library from https://github.com/requests/requests
# overriding requests.Session.rebuild_auth to mantain headers when redirected
# The user credentials that will be used to authenticate access to the data
class SessionWithHeaderRedirection(requests.Session):
    AUTH_HOST = 'urs.earthdata.nasa.gov'
    def __init__(self, username, password):
        super().__init__()
        self.auth = (username, password)
   # Overrides from the library to keep headers when redirected to or from
   # the NASA auth host.

    def rebuild_auth(self, prepared_request, response):
        headers = prepared_request.headers
        url = prepared_request.url
        if 'Authorization' in headers:
            original_parsed = requests.utils.urlparse(response.request.url)
            redirect_parsed = requests.utils.urlparse(url)
            if (original_parsed.hostname != redirect_parsed.hostname) and redirect_parsed.hostname != self.AUTH_HOST and original_parsed.hostname != self.AUTH_HOST:
                del headers['Authorization']
        return

from pathlib import Path

def download_file(session, url, file_path=Path.home() / ".local/share/earthdata_manager"):

    # extract the filename from the url to be used when saving the file
    filename = url[url.rfind('/')+1:]  

    try:
        # submit the request using the session
        response = session.get(url, stream=True)
        print(response.status_code)
        # raise an exception in case of http errors
        response.raise_for_status()  
        # save the file
        with open(filename, 'wb') as fd:
            for chunk in response.iter_content(chunk_size=1024*1024):
                fd.write(chunk)
    except requests.exceptions.HTTPError as e:
        # handle any errors here
        print(e)

class EarthDataManager:
    """
    A class to manage Earth data downloads, specifically RINEX files, and maintain a record of downloaded files to avoid duplicates.
    Attributes:
    -----------
    username : str
        The username for authentication.
    password : str
        The password for authentication.
    session : SessionWithHeaderRedirection
        A session object to handle authenticated requests.
    Methods:
    --------
    __init__(username, password):
        Initializes the EarthDataManager with the provided username and password, sets up the session, and prepares the database.
    download_rinex_file(year, doy, file_type="GPS", frequency="daily", version="V2"):
        Downloads a RINEX file for the specified year and day of year (doy) with optional parameters for file type, frequency, and version.
    """
    
    def __init__(self, username, password):
        self.username = username
        self.password = password
        self.session = SessionWithHeaderRedirection(username, password)
        # create database as a dictionary with keys as year.doy for storing record of all our downloaded products
        # We will want to avoid downloading the same file multiple times
        # Lets create a directory in ~/.local/share/earthdata_manager to store the database and all the downloaded files
        # We will also store the log file in this directory
        # The database will be stored as a json file
        # The database will be read at the start of the program and written at the end of the program
        # The database will be updated with the new downloaded files
        # The database will be used to check if a file has already been downloaded
        
        # make sure the database file exists
        # read the database file
    
    def download_status_file(self, year, doy):
        status_url = get_status_url(year, doy)
        download_file(self.session, status_url)

    def download_rinex_file(self, year, doy, file_type="GPS", frequency="daily", version="V2"):
        rinex_url = get_rinex_url(year, doy, file_type, frequency, version)
        download_file(self.session, rinex_url)

def main():
    username = "mathew.cosgrove"
    password = "Pgatour95!!!"
    # create session with the user credentials that will be used to authenticate access to the data
    session = SessionWithHeaderRedirection(username, password)
    year,doy = get_year_doy()
    print(f"{year}-{doy}")
    rinex_url = get_rinex_url(year, doy, file_type="GPS", frequency="daily", version="V2")
    print(f"{rinex_url}")
    download_file(session, rinex_url)

if __name__ == "__main__":
    main()


def other_method():
    # The url of the file we wish to retrieve
    url = "https://daacdata.apps.nsidc.org/pub/DATASETS/nsidc0192_seaice_trends_climo_v3/total-ice-area-extent/nasateam/gsfc.nasateam.month.anomaly.area.1978-2021.s"

    # Create a password manager to deal with the 401 reponse that is returned from
    # Earthdata Login

    password_manager = urllib.request.HTTPPasswordMgrWithDefaultRealm()
    password_manager.add_password(None, "https://urs.earthdata.nasa.gov", username, password)

    # Create a cookie jar for storing cookies. This is used to store and return
    # the session cookie given to use by the data server (otherwise it will just
    # keep sending us back to Earthdata Login to authenticate).  Ideally, we
    # should use a file based cookie jar to preserve cookies between runs. This
    # will make it much more efficient.

    cookie_jar = CookieJar()
    # Install all the handlers.

    opener = urllib.request.build_opener(
        urllib.request.HTTPBasicAuthHandler(password_manager),
        #urllib.request.HTTPHandler(debuglevel=1),    # Uncomment these two lines to see
        #urllib.request.HTTPSHandler(debuglevel=1),   # details of the requests/responses
        urllib.request.HTTPCookieProcessor(cookie_jar))
    urllib.request.install_opener(opener)


    # Create and submit the request. There are a wide range of exceptions that
    # can be thrown here, including HTTPError and URLError. These should be
    # caught and handled.

    request = urllib.request.Request(url)
    response = urllib.request.urlopen(request)
    # Print out the result (not a good idea with binary data!)

    body = response.read()
    print(body)
