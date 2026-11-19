# Berita Indonesia (news_app)

Aplikasi berita Indonesia berbasis Flutter dengan GNews API (Tugas Pemrograman Mobile Topic 11).

## Fitur
- Berita per kategori (Teknologi, Olahraga, Bisnis, Sains, Hiburan, Kesehatan)
- Pencarian berita dan halaman detail
- Penanganan error: tidak ada koneksi, timeout, API key tidak valid, kuota habis, server bermasalah

## Screenshot
Tidak ada koneksi internet:

![Error koneksi](error_koneksi.png)

API key tidak valid:

![Error API key](error_api_key.png)

## Cara Menjalankan
1. `flutter create . --platforms=android`
2. `flutter pub get`
3. `flutter run --dart-define=GNEWS_API_KEY=KEY_KAMU`
