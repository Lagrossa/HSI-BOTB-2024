import pandas as pd
from datetime import datetime
from flask import Flask, request, jsonify

import http.server
import socketserver
PORT=8000
Handler=http.server.SimpleHTTPRequestHandler

with socketserver.TCPServer(("", PORT), Handler) as httpd:
    print("Serving at port", PORT)
    httpd.serve_forever()

app = Flask(__name__)

# Function to determine usability based on fabric type
def is_usable(fabric_type):
    usable_fabrics = ['Cotton', 'Polyester', 'Silk']
    return fabric_type in usable_fabrics

# Load existing Excel sheet
excel_file_path = 'C:/Users/a463f/OneDrive/Documents/HSI-BOTB-2024lib/GatherCollectdata/fabric_data.csv'
df = pd.read_excel(excel_file_path)

@app.route('/add_fabric', methods=['POST'])
def add_fabric():
    # Gather data from Flutter app
    data = request.json
    fabric_type = data.get('fabric_type')
    percentage = data.get('percentage')
    feedback = data.get('feedback')
    color = data.get('color')
    
    # Get the current date
    date = datetime.now().strftime("%Y-%m-%d")
    
    # Determine usability
    usable = is_usable(fabric_type)
    
    # Create a new DataFrame with the collected data
    new_data = pd.DataFrame({
        'Date': [date],
        'Fabric Type': [fabric_type],
        'Percentage': [percentage],
        'Usable': [usable],
        'Feedback': [feedback],
        'Color': [color]
    })
    
    # Append new data to the existing DataFrame
    global df  # Declare df as global to modify it
    df = pd.concat([df, new_data], ignore_index=True)
    
    # Save the updated DataFrame to Excel
    df.to_excel(excel_file_path, index=False)
    
    return jsonify({"message": "Data successfully collected and saved to Excel."}), 200

if __name__ == '__main__':
    app.run(debug=True)
