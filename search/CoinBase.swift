////
//  Created by Yasmin Abdi on 5/1/19.
//  Copyright © 2019 Yasmin Abdi. All rights reserved.
//

//
//    import Foundation
//
//
//    API_KEY = 'API_KEY'
//    API_SECRET = 'API_SECRET'
//
//    # Create custom authentication for Coinbase API
//    class CoinbaseWalletAuth(AuthBase):
//    def __init__(self, api_key, secret_key):
//    self.api_key = api_key
//    self.secret_key = secret_key
//
//    def __call__(self, request):
//    timestamp = str(int(time.time()))
//    message = timestamp + request.method + request.path_url + (request.body or '')
//    signature = hmac.new(self.secret_key, message, hashlib.sha256).hexdigest()
//
//    request.headers.update({
//    'CB-ACCESS-SIGN': signature,
//    'CB-ACCESS-TIMESTAMP': timestamp,
//    'CB-ACCESS-KEY': self.api_key,
//    })
//    return request
//
//    api_url = 'https://api.coinbase.com/v2/'
//    auth = CoinbaseWalletAuth(API_KEY, API_SECRET)
//
//    # Get current user
//    r = requests.get(api_url + 'user', auth=auth)
//    print r.json()
//    # {u'data': {u'username': None, u'resource': u'user', u'name': u'User'...
//
//    # Send funds
//    tx = {
//    'type': 'send',
//    'to': 'user@example.com',
//    'amount': '10.0',
//    'currency': 'USD',
//    }
//    r = requests.post(api_url + 'accounts/primary/transactions', json=tx, auth=auth)
//    print r.json()
//
