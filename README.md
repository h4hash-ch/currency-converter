# 💱 Currency Converter

A modern Flutter application for real-time currency conversion with support for 150+ currencies worldwide.

## ✨ Features

- 🌍 Real-time exchange rates from CurrencyAPI
- 💰 Support for 150+ global currencies
- 🌙 Beautiful dark mode UI
- 🔄 Quick currency swap functionality
- ✨ Smooth animations and transitions
- 📱 Cross-platform support (Android, iOS, Web, Desktop)

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.0 or higher)
- Dart SDK
- A free API key from [CurrencyAPI.net](https://currencyapi.net)

### Installation

1. **Clone the repository**
```bash
   git clone https://github.com/h4hash-ch/currency-converter.git
   cd currency-converter
```

2. **Get your API key**
    - Visit [CurrencyAPI.net](https://currencyapi.net)
    - Sign up for a free account
    - Copy your API key

3. **Set up environment variables**

   Create a `.env` file in the project root:
```bash
   cp .env.example .env
```

Open `.env` and add your API key:
```env
   CURRENCY_API_KEY=your_actual_api_key_here
```

4. **Install dependencies**
```bash
   flutter pub get
```

5. **Run the app**
```bash
   flutter run
```

## 🛠️ Built With

- **Flutter** - UI framework
- **Dart** - Programming language
- **flutter_dotenv** - Environment variable management
- **http** - API requests
- **CurrencyAPI** - Exchange rate data provider

## 📁 Project Structure
```
lib/
├── main.dart                    # App entry point
├── home_page.dart              # Main converter UI
└── Services/
    └── currency_api.dart       # API service layer
```

## 🔒 Security

- API keys are stored in `.env` file (not tracked by Git)
- Use `.env.example` as a template for other developers to replace their own API key

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👨‍💻 Author

**h4hash-ch**
- GitHub: [@h4hash-ch](https://github.com/h4hash-ch)

## 🙏 Acknowledgments

- Exchange rate data provided by [CurrencyAPI.net](https://currencyapi.net)
- Flutter team for the amazing framework
- Icons from [Material Design](https://material.io/design)

## 🔄 Version History

- **v1.0.0** (January 2026)
    - Initial release
    - Real-time currency conversion
    - Support for 150+ currencies
    - Dark mode UI

---