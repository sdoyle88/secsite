import requests

def fetch_data(url):
    try:
        response = requests.get(url)
        if response.status_code == 200:
            return response.content
        else:
            return f"Error: {response.status_code}"
    except requests.RequestException as e:
        return f"Request failed: {e}"

if __name__ == "__main__":
    url = "http://example.com"
    data = fetch_data(url)
    print(data)
