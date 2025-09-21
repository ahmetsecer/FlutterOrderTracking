# 📦 Flutter Sipariş Takip Uygulaması

Gradient kullanmadan modern **Material 3** arayüzle geliştirilmiş, gerçek iş senaryolarına uygun **Sipariş Takip** uygulaması.  
Durum sekmeleri (sayaçlı), **tarih aralığı** filtresi, **sıralama**, **arama**, detay sayfasında **kalemler & adres**, **kalıcı kullanıcı tercihleri** ve **açık/koyu tema** içerir.

[![CI](https://github.com/<username>/<repo>/actions/workflows/flutter-ci.yml/badge.svg)](https://github.com/<username>/<repo>/actions)
[![License: MIT](https://img.shields.io/badge/License-MIT-informational.svg)](LICENSE)
![Flutter](https://img.shields.io/badge/Flutter-Material%203-blue)

> **Canlı Demo (isteğe bağlı):** `https://<username>.github.io/<repo>/`  
> (Repo’da GitHub Pages’i Actions ile etkinleştirirsen otomatik yayınlanır.)

---

## ✨ Özellikler
- **Durum sekmeleri** (sayaçlı): Tümü / Yeni / Hazırlanıyor / Kargoda / İptal-Değişim-İade / İptal  
- **Tarih aralığı filtresi** (DateRangePicker) + **arama** (müşteri adı / sipariş no)  
- **Sıralama**: Tarih ↑↓, Tutar ↑↓  
- **Detay sayfası**: ürün kalemleri, satır tutarları, teslimat adresi  
- **Kalıcı tercihler**: tarih filtresi & sıralama `shared_preferences` ile saklanır  
- **Tema**: Açık/Koyu (toggle)  
- **Çoklu platform**: Android, iOS, Web, Windows

---

## 🧭 İçindekiler
- [Kurulum](#-kurulum)
- [Çalıştırma](#-çalıştırma)
- [Web Build / GitHub Pages](#-web-build--github-pages)
- [Proje Yapısı](#-proje-yapısı)
- [Mock Veri & Gerçek API](#-mock-veri--gerçek-api)
- [Ekran Görüntüleri](#-ekran-görüntüleri)
- [Katkı](#-katkı)
- [Lisans](#-lisans)
- [English README](#-english-readme)

---

## 🔧 Kurulum
Ön koşul: **Flutter (stable)** yüklü olmalı.
```bash
flutter --version
