
import re

INPUT_FILE = r"lib\data\sections\trivia_data.dart"

def sanitize_filename(text):
    safe_text = re.sub(r'[^\w\s-]', '', text).strip().lower()
    safe_text = re.sub(r'[\s-]+', '_', safe_text)
    return safe_text[:50]

def parse_dart_data(file_path):
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    questions = []
    chunks = content.split('Question(')
    
    for chunk in chunks[1:]:
        question_data = {}
        # distinct text: '...' or text: "..."
        text_match = re.search(r"text:\s*(['\"])(.*?)\1,", chunk, re.DOTALL)
        if text_match:
            question_data['text'] = text_match.group(2).replace('\n', ' ').strip()
        
        options_match = re.search(r"options:\s*\[(.*?)\]", chunk, re.DOTALL)
        if options_match:
            options_str = options_match.group(1)
            opts = re.findall(r"(['\"])((?:\\\1|.)*?)\1", options_str)
            question_data['options'] = [o[1].replace('\\' + o[0], o[0]).strip() for o in opts]
            
        if 'text' in question_data and 'options' in question_data:
            questions.append(question_data)
            
    return questions

questions = parse_dart_data(INPUT_FILE)
found_issue = False
for q in questions:
    for opt in q['options']:
        fname = sanitize_filename(opt)
        if not fname:
            print(f"ISSUE FOUND: Question '{q['text']}' has Option '{opt}' which maps to empty filename!")
            found_issue = True

if not found_issue:
    print("No answers mapped to empty filenames found in current data.")
