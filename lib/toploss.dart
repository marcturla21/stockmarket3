// toploss.dart

class TopLossApiUrl {
  // Define your API URL directly without combining it with the API key
  static const String _baseUrl = 'https://www.alphavantage.co/query?function=TOP_GAINERS_LOSERS&apikey=demo'; //alphavantage free api without api key

  // Method to return the API URL
  static String get topLossUrl => _baseUrl;
}