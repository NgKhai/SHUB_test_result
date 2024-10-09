import requests
import json

# INPUT
response = requests.get('https://test-share.shub.edu.vn/api/intern-test/input')
input_data = response.json()

token = input_data['token']
data = input_data['data']
queries = input_data['query']

n = len(data)

# Create prefix sum
prefix_sum = [0] * (n + 1)  # Total for type 1 queries
even_sum = [0] * (n + 1)     # Total for even indices
odd_sum = [0] * (n + 1)      # Total for odd indices

for i in range(n):
    prefix_sum[i + 1] = prefix_sum[i] + data[i]
    even_sum[i + 1] = even_sum[i] + (data[i] if i % 2 == 0 else 0)
    odd_sum[i + 1] = odd_sum[i] + (data[i] if i % 2 != 0 else 0)

# Check type 1 or 2
results = []
for query in queries:
    l, r = query['range']
    if query['type'] == "1":
        # Type 1: Calculate the sum in the range [l, r]
        # data[l] + data[l + 1] + data[l + 2] + ... + data[r - 1] + data[r]

        total_sum = prefix_sum[r + 1] - prefix_sum[l]
        results.append(total_sum)
    elif query['type'] == "2":
        # Type 2: Calculate the even sum minus the odd sum in the range [l, r]
        # data[l] - data[l + 1] + data[l + 2] - data[l + 3] + ... ± data[r - 1] ± data[r]

        total_even = even_sum[r + 1] - even_sum[l]
        total_odd = odd_sum[r + 1] - odd_sum[l]
        result = total_even - total_odd
        results.append(result)

# OUTPUT
output_url = 'https://test-share.shub.edu.vn/api/intern-test/output'
headers = {
    'Authorization': f'Bearer {token}',
    'Content-Type': 'application/json'
}

response = requests.post(output_url, headers=headers, data=json.dumps(results))

if response.status_code == 200:
    print("Success!")
else:
    print("Error:", response.text)
