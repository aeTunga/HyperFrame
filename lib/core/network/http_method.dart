/// HTTP Request Methods
///
/// Enum representing standard HTTP methods for API requests.
/// Used by NetworkManager to determine the type of request to make.
enum HttpMethod {
  /// HTTP GET - Retrieve data
  get,

  /// HTTP POST - Create new resource
  post,

  /// HTTP PUT - Update existing resource (full update)
  put,

  /// HTTP PATCH - Partially update resource
  patch,

  /// HTTP DELETE - Delete resource
  delete,

  /// HTTP HEAD - Retrieve headers only
  head,

  /// HTTP OPTIONS - Retrieve supported methods
  options;

  /// Get uppercase string representation
  /// Example: HttpMethod.get.name → 'GET'
  String get value => name.toUpperCase();
}
