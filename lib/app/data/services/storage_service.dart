/// Lightweight in-memory storage service.
///
/// Replace this with a persistent solution (e.g. get_storage, shared_preferences,
/// or flutter_secure_storage) once you need the token/user data to survive
/// app restarts.
class StorageService {
  String? token;

  void clearToken() => token = null;
}
