# Ledger App

A fast, secure, and offline-first personal finance tracker built with Flutter. Ledger App provides deep insights into
your financial habits through predictive analytics, all secured behind local authentication.

## Demo

<video src="assets/mp4/demo.mp4" width="100%" controls autoplay loop></video>

*(If the video does not render natively in your viewer, [click here to download or view it](assets/mp4/demo.mp4))*

## Features

* **Smart Analytics & Forecasting:** Visualizes income and expenses via interactive charts (`fl_chart`) and predicts
  end-of-month spending using historical data algorithms.
* **Secure Access:** Custom-built PIN pad and biometric authentication (Face ID / Touch ID) to protect sensitive
  financial data.
* **Offline-First Storage:** All transactions, accounts, and categories are stored locally on the device for maximum
  privacy.
* **Multi-Currency Support:** Dynamically formats diverse currencies with locale-aware precision.
* **Native iOS Aesthetics:** Built entirely with Cupertino widgets, offering a seamless Apple-like user experience with
  full Light and Dark mode support.

## Architecture & Tech Stack

The codebase is structured around Clean Architecture and Domain-Driven Design (DDD) principles, ensuring clear
separation of concerns, scalability, and robust boundary enforcement.

* **Framework:** Flutter / Dart
* **State Management:** BLoC (Business Logic Component)
* **Local Database:** Drift (SQLite)
* **Charts:** fl_chart

## Getting Started

1. **Clone the repository:**
   ```bash
   git clone [https://github.com/k0zlov/ledger-app.git](https://github.com/k0zlov/ledger-app.git)
   cd ledger-app