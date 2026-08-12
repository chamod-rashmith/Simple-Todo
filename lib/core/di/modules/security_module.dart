import 'package:get_it/get_it.dart';
import '../../security/data/aes_encryption_service.dart';
import '../../security/data/flutter_secure_storage_service.dart';
import '../../security/domain/i_encryption_service.dart';
import '../../security/domain/i_secure_storage_service.dart';

void initSecurityModule(GetIt sl) {
  // Secure Storage Service
  sl.registerLazySingleton<ISecureStorageService>(
    () => FlutterSecureStorageService(),
  );

  // Encryption Service
  sl.registerLazySingleton<IEncryptionService>(
    () => AESEncryptionService(
      sl<ISecureStorageService>(),
    ),
  );
}
