# ChatGPT Conversation Filter and Browser Tool

`process_chatgpt.sh` is a tool for filtering and opening exported ChatGPT conversations based on a keyword search. It provides an interactive way to search through your chat history, save results, and optionally open matching conversations directly in your browser.

---

## Features

- **Filter Conversations**: Search through your exported ChatGPT conversation history (`conversations.json`) for specific keywords.
- **Save Filtered Results**: Save matching conversations as a JSON file in a timestamped output directory.
- **Open Conversations in Browser**: Automatically generate URLs for matching conversations and open them in your default browser.
- **Interactive Input**: User-friendly prompts for input file, search term, and output directory.

---

## Installation

1. Ensure you have `jq` installed:

   ```
   sudo apt-get install jq    # For Ubuntu/Debian
   brew install jq            # For macOS
   ```

2. Clone the repository:

   ```
   git clone https://github.com/your-repo/chatgpt-conversation-filter.git
   cd chatgpt-conversation-filter
   ```

3. Make the scripts executable:

   ```
   chmod +x *.sh
   ```

---

## Usage

### Basic Workflow

Run the script interactively:

```
./process_chatgpt.sh
```

### Example

```
Enter the input file path (default: conversations.json):
Enter the keyword to search for: Jimi Hendrix
Enter the output directory (default: output_20250113_224928):
Filtering conversations with keyword: 'Jimi Hendrix'...
Filtered conversations saved to 'output_20250113_224928/filtered_conversations.json'.
Found 12 matching conversations. Do you want to open all URLs in your browser? (y/n)
y
Opening 12 URLs...
Process complete. Filtered conversations saved in 'output_20250113_224928'.
```

---

## How It Works

1. **Filtering**: The script uses `jq` to search for matching keywords in the `title` or message content of each conversation.
2. **Saving Results**: Filtered results are saved in a `filtered_conversations.json` file within a timestamped output directory.
3. **Opening Browser Tabs**: For each matching conversation, a URL is generated and optionally opened in the browser.

---

## Notes

- Ensure your exported ChatGPT history (`conversations.json`) is in the same directory as the script or provide the full path when prompted.
- Large datasets may take time to process. Be patient when running the script.

---

## License

This project is licensed under the MIT License. See the `LICENSE` file for details.


