import subprocess


def get_usbserial_devices():
  serial_devices = None
  try:
    # list_files = subprocess.run(["ls /dev/ttyUSB*"], shell=True, stdout=subprocess.PIPE, text=True)
    serial_devices = subprocess.check_output('ls /dev/ttyUSB*', shell=True, stderr=subprocess.DEVNULL, text=True)
    serial_devices = serial_devices.split('\n')[:-1]
    # serial_devies.pop()
  except Exception as e:
    pass
  return serial_devices


def get_serial_number(device):
  serial_number = subprocess.check_output("udevadm info -a -n %s | grep \'{serial}\' | grep -v \".usb\"; " % device, shell=True, stderr=subprocess.DEVNULL, text=True).split("==")[1].split("\"")[1]
  print(serial_number)


def get_serial_numbers(devices):
  for d in devices:
    print(d)
    get_serial_number(d)

# list_files = subprocess.run(["for dev in `ls /dev/ttyUSB*`; do echo $dev && udevadm info -a -n $dev | grep '{serial}' | grep -v \".usb\"; done;"])
# list_files = subprocess.run(["ls", "/dev/tty*"])
# list_files = subprocess.check_output('ls /dev/tty*', shell=True)
# list_files = subprocess.call('ls /dev/tty*', shell=True)
# list_files = subprocess.run(["ls /dev/ttyUSB*"], shell=True, stdout=subprocess.PIPE, text=True)
# try:
#   # list_files = subprocess.run(["ls /dev/ttyUSB*"], shell=True, stdout=subprocess.PIPE, text=True)
#   list_files = subprocess.check_output('ls /dev/tty*', shell=True, stderr=subprocess.DEVNULL, text=True)
# except Exception as e:
#   pass
# list_files = list_files.trim().split('\n')
devices = get_usbserial_devices()
get_serial_numbers(devices)
# print(list_files.stdout)  # Hello from the other side
# print(type(list_files))
# print("The exit code was: %d" % list_files.returncode)
