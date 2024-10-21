from pymongo import MongoClient
from bson import ObjectId

from datetime import datetime

# Connect to MongoDB - replace with your connection string
connection_string = "mongodb://root:example@192.168.50.49:27017/?authSource=admin&readPreference=primary&ssl=false&directConnection=true"
client = MongoClient(connection_string)

# Database and Collection Setup
db_tech_docs = client["TechnicalDocuments"]
col_manuals = db_tech_docs["Manuals"]
col_specifications = db_tech_docs["Specifications"]

db_research_papers = client["ResearchPapers"]
col_journals = db_research_papers["Journals"]
col_conferences = db_research_papers["Conferences"]

db_code_repos = client["CodeRepositories"]
col_projects = db_code_repos["Projects"]
col_libraries = db_code_repos["Libraries"]

db_proposals = client["ProposalTexts"]
col_business_proposals = db_proposals["BusinessProposals"]
col_research_proposals = db_proposals["ResearchProposals"]

# Sample Data Models (Schemas)
# Technical Manuals
manual_schema = {
    "_id": ObjectId(),
    "title": "Manual Title",
    "content": "Content of the manual",
    "tags": ["tag1", "tag2"],
    "created_at": datetime.now()
}

# Research Journal Papers
journal_paper_schema = {
    "_id": ObjectId(),
    "title": "Paper Title",
    "abstract": "Abstract of the paper",
    "authors": ["Author 1", "Author 2"],
    "published_date": datetime.now(),
    "keywords": ["keyword1", "keyword2"]
}

# Code Projects
project_schema = {
    "_id": ObjectId(),
    "name": "Project Name",
    "repository_link": "URL to repository",
    "description": "Project Description",
    "created_at": datetime.now(),
    "languages": ["Python", "JavaScript"]
}

# Business Proposals
business_proposal_schema = {
    "_id": ObjectId(),
    "title": "Proposal Title",
    "summary": "Summary of the proposal",
    "submitted_to": "Company/Individual Name",
    "submitted_by": "Your Company/Name",
    "submission_date": datetime.now()
}

# Note: These are basic schema templates. You can customize them as per your specific requirements.

mydict = { "name": "John", "address": "Highway 37" }

x = col_manuals.insert_one(mydict)

# client.database_names()

db = client.store_db
transactions = db.transactions
doc_data = {
    'store_name': 'sportsmans', 
    'branch_name': 'tygervalley', 
    'account_id': 'sns_03821023', 
    'total_costs': 109.20, 
    'products_purchased': ['cricket bat', 'cricket ball', 'sports hat'], 
    'purchase_method': 
    'credit card'
}
response = transactions.insert_one(doc_data)
response.inserted_id
ObjectId('5cad16a5a5f3826f6f046d74')