
import json
import time
import argparse
from datetime import datetime

import nltk
from nltk.corpus import stopwords
from nltk.stem import WordNetLemmatizer
from nltk.tokenize import word_tokenize

from sklearn.feature_extraction.text import CountVectorizer
from sklearn.decomposition import LatentDirichletAllocation

# Pretty Print
from pprint import pprint

HTML_TEMPLATE = """
<html>
  <head>
    <title>ChatGPT Data Export</title>
    <style>
      body {
        margin: 20px;
      }
      h4 {
        font-family: sans-serif;
        margin: 0;
      }
      #root {
        display: flex;
        flex-direction: column;
        gap: 20px;
      }
      .conversation {
        border: 1px solid black;
        padding: 20px;
        background-color: #f3f3f3;
      }
      .message {
        white-space: pre-wrap;
        margin: 20px 0;
      }
      .author {
        font-weight: bold;
        margin-bottom: 4px;
      }
      .author::first-letter {
        text-transform: uppercase;
      }
    </style>
    <script>
      var jsonData = {recent_conversations};

      function getConversationMessages(conversation) {
          var messages = [];
          var currentNode = conversation.current_node;
          while (currentNode != null) {
              var node = conversation.mapping[currentNode];
              if (
                  node.message &&
                  node.message.content &&
                  node.message.content.content_type == "text"
                  && node.message.content.parts.length > 0 &&
                  node.message.content.parts[0].length > 0 &&
                  (node.message.author.role !== "system"  || node.message.metadata.is_user_system_message)
              ) {
                  author = node.message.author.role;
                  if (author === "assistant") {
                      author = "ChatGPT";
                  } else if (author === "system" && node.message.metadata.is_user_system_message) {
                      author = "Custom user info"
                  }
                  messages.push({ author, text: node.message.content.parts[0] });
              }
              currentNode = node.parent;
          }
          return messages.reverse();
      }

      // on load, add messages to the root div
      window.onload = function() {
          var root = document.getElementById("root");
          for (var i = 0; i < jsonData.length; i++) {
              var conversation = jsonData[i];
              var messages = getConversationMessages(conversation);
              var div = document.createElement("div");
              div.className = "conversation";
              div.innerHTML = "<h4>" + conversation.title + "</h4>";
              for (var j = 0; j < messages.length; j++) {
                  var message = document.createElement("pre");
                  message.className = "message";
                  message.innerHTML = `<div class="author">${messages[j].author}</div><div>${messages[j].text}</div>`;
                  div.appendChild(message);
              }
              root.appendChild(div);
          }
      }
    </script>
  </head>
  <body>
    <div id="root"></div>
  </body>
</html>
"""

def filter_recent_conversations(file_path, days):
    # Load the conversations from the JSON file
    with open(file_path, 'r') as file:
        conversations = json.load(file)

    # Get the current time in seconds since the epoch
    current_time = time.time()

    # Filter out conversations that are older than the specified days
    time_in_seconds = days * 24 * 60 * 60
    
    # Get date of earliest conversation in filter
    earliest_conversation = current_time - time_in_seconds
    
    # Create string of earliest conversation date
    earliest_conversation_date = time.strftime('%Y%m%d%H%M%S', time.localtime(earliest_conversation))
    recent_conversations = [conv for conv in conversations if current_time - conv['create_time'] <= time_in_seconds]
    
    return recent_conversations, earliest_conversation_date

def filter_conversations_by_date(file_path, start_date, end_date):
    # Convert start and end dates to timestamps
    start_timestamp = time.mktime(datetime.strptime(start_date, "%Y-%m-%d").timetuple())
    end_timestamp = time.mktime(datetime.strptime(end_date, "%Y-%m-%d").timetuple())

    # Load the conversations from the JSON file
    with open(file_path, 'r') as file:
        conversations = json.load(file)

    # Filter out conversations based on the start and end timestamps
    filtered_conversations = [conv for conv in conversations if start_timestamp <= conv['create_time'] <= end_timestamp]
    
    return filtered_conversations
  

def get_titles(conversations):
    # Print the titles of the filtered conversations
    return [conv['title'] for conv in conversations]
  
def generate_html(filtered_conversations, start_date, end_date):
    # HTML template with a placeholder for the filtered conversations
    html_template = HTML_TEMPLATE

    # Embed the filtered conversations into the HTML template
    html_content = html_template.replace("{recent_conversations}", json.dumps(filtered_conversations, indent=4))

    # Create the output filename with the start and end dates
    output_filename = f"conversations_{start_date}_to_{end_date}.html"

    # Write the generated HTML content to the output file
    with open(output_filename, 'w') as file:
        file.write(html_content)

    print(f"Generated '{output_filename}' with {len(filtered_conversations)} conversations.")




# Ensure resources are available
nltk.download('stopwords', quiet=True)
nltk.download('punkt', quiet=True)
nltk.download('wordnet', quiet=True)

# Initialize lemmatizer and stop words
lemmatizer = WordNetLemmatizer()
stop_words = set(stopwords.words('english'))

# Preprocess titles
def preprocess_title(title):
    # Tokenize and lowercase
    tokens = word_tokenize(title.lower())
    
    # Remove stop words and non-alphabetic tokens, then lemmatize
    return [lemmatizer.lemmatize(token) for token in tokens if token.isalpha() and token not in stop_words]

def get_topics(titles):
  
    # Preprocess titles
    preprocessed_titles = [preprocess_title(title) for title in titles]
    
    # Convert list of tokens back to string for vectorization
    titles_str = [' '.join(tokens) for tokens in preprocessed_titles]

    # Vectorization
    vectorizer = CountVectorizer(max_df=0.95, min_df=2, max_features=1000)
    X = vectorizer.fit_transform(titles_str)

    # Apply LDA
    num_topics = 100
    # Adjusting the number of topics and reapplying LDA
    # num_topics = 5
    
    lda = LatentDirichletAllocation(n_components=num_topics, max_iter=10, random_state=0)
    lda.fit(X)

    # Extract topics and words associated with each topic
    topics = dict()
    for idx, topic in enumerate(lda.components_):
        features = [vectorizer.get_feature_names_out()[i] for i in topic.argsort()[-5:][::-1]]
        topics[idx] = features
    
    title_tags = dict() 
    for title in titles:
      title_vec = vectorizer.transform([title])
      topic_prob = lda.transform(title_vec)
      title_tags[title] = topics[topic_prob.argmax()]
      
    return topics, title_tags



def get_keywords(titles):
  
  preprocessed_titles = [preprocess_title(title) for title in titles]
  titles_str = [' '.join(tokens) for tokens in preprocessed_titles]

# Function to select titles based on a keyword
def select_titles_by_keyword(keyword, title_tags):
    return [title for title, tags in title_tags.items() if keyword in tags]


def main():
    parser = argparse.ArgumentParser(description="Generate an HTML file with conversations from a given JSON file filtered by start and end dates.")
    # list titles
    parser.add_argument("--list-titles", action="store_true", help="List the titles of the filtered conversations.")
    parser.add_argument("file_path", type=str, help="Path to the conversations.json file.")
    parser.add_argument("days", type=int, help="Number of days to filter conversations by.")
    # parser.add_argument("start_date", type=str, help="Start date in the format YYYY-MM-DD.")
    # parser.add_argument("end_date", type=str, help="End date in the format YYYY-MM-DD.")
    
    args = parser.parse_args()
    recent_conversations, earliest_conversation_date = filter_recent_conversations(args.file_path, args.days)
    
    titles = get_titles(recent_conversations)
    
    if args.list_titles:
      print(titles)

    topics, title_tags = get_topics(titles)
    # Testing with the keyword 'gps'
    selected_titles = select_titles_by_keyword('gps', title_tags)
    pprint(topics)
    # Pretty Print the title tags
    pprint(title_tags)
    pprint(selected_titles[:10])
    # filtered_conversations = filter_conversations_by_date(args.file_path, args.start_date, args.end_date)
    # generate_html(filtered_conversations, args.start_date, args.end_date)

if __name__ == "__main__":
    main()

