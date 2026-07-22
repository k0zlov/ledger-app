# Ledger App

A fast, secure, and offline-first personal finance tracker built with Flutter. Ledger App provides deep insights into
your financial habits through predictive analytics, all secured behind local authentication.

## Demo

[![Ledger App Demo](https://img.youtube.com/vi/urRTWaSsys8/0.jpg)](https://youtube.com/shorts/urRTWaSsys8)

*(Click the image above to watch the demo on YouTube)*

## Features

* **Smart Analytics & Forecasting:** Visualizes income and expenses via interactive charts (`fl_chart`) and predicts
  end-of-month spending using historical data algorithms.
* **Secure Access:** Custom-built PIN pad and biometric authentication (Face ID / Touch ID) to protect sensitive
  financial data.
* **Offline-First Storage:** All transactions, accounts, and categories are stored locally on the device for maximum
  privacy.
* **Multi-Language Support:** Fully localized in English (EN), Ukrainian (UK), and Russian (RU).
* **Multi-Currency Support:** Dynamically formats diverse currencies with locale-aware precision.
* **Native iOS Aesthetics:** Built entirely with Cupertino widgets, offering a seamless Apple-like user experience with
  full Light and Dark mode support.

## Architecture & Tech Stack

The codebase is structured around **Clean Architecture** and **Domain-Driven Design (DDD)** principles, ensuring clear
separation of concerns, scalability, and robust boundary enforcement.

* **Framework:** Flutter / Dart
* **State Management:** BLoC (Business Logic Component)
* **Local Database:** Drift (SQLite)
* **Charts:** fl_chart

## Getting Started

Follow these steps to set up and run the project locally.

### Prerequisites

Ensure you have the [Flutter SDK](https://docs.flutter.dev/get-started/install) installed on your machine.

### Installation

**1. Clone the repository**

```bash
git clone https://github.com/k0zlov/ledger-app.git
cd ledger-app
```

**2. Install dependencies**

```bash
flutter pub get
```

**3. Run the app**

```bash
flutter run
```