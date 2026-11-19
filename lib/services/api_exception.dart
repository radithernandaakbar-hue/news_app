enum ApiErrorType {
  noConnection,
  timeout,
  invalidKey,
  quotaExceeded,
  serverError,
  badResponse,
  unknown,
}

/// Exception khusus API. Setiap jenis error punya pesan berbeda.
class ApiException implements Exception {
  const ApiException(this.type, this.message);

  final ApiErrorType type;
  final String message;

  const ApiException.noConnection()
      : this(ApiErrorType.noConnection,
            'Tidak ada koneksi internet. Periksa jaringanmu lalu coba lagi.');

  const ApiException.timeout()
      : this(ApiErrorType.timeout,
            'Server terlalu lama merespons. Coba lagi sebentar lagi.');

  const ApiException.invalidKey()
      : this(ApiErrorType.invalidKey,
            'API key tidak valid. Periksa konfigurasi API key GNews.');

  const ApiException.quotaExceeded()
      : this(ApiErrorType.quotaExceeded,
            'Kuota API harian sudah habis. Coba lagi besok.');

  const ApiException.serverError()
      : this(ApiErrorType.serverError,
            'Server GNews sedang bermasalah. Coba lagi nanti.');

  const ApiException.badResponse()
      : this(ApiErrorType.badResponse,
            'Data dari server tidak dapat dibaca.');

  const ApiException.unknown()
      : this(ApiErrorType.unknown, 'Terjadi kesalahan yang tidak diketahui.');

  @override
  String toString() => message;
}
