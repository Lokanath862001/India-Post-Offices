# Privacy Policy for India Post Offices

**Effective Date:** October 9, 2026  
**Application Name:** India Post Offices  
**Package Name:** `com.oedc.indiaPostOffices`  
**Developer:** Shree Lakshmi Ventures (SLV)  

---

## 1. Overview & Non-Affiliation Disclaimer

**Shree Lakshmi Ventures** ("we", "our", or "us") developed the **India Post Offices** application as an independent utility directory to help users search, explore, and access postal PIN code information across India.

> ### **Government Non-Affiliation Disclaimer**
> **India Post Offices is an independent utility application developed by Shree Lakshmi Ventures. This application is NOT affiliated with, endorsed by, sponsored by, authorized by, or in any way officially connected with India Post (Department of Posts, Ministry of Communications), the Government of India, or any state government entity.**  
>
> **The application does not represent any government entity and does not provide official government services (such as parcel booking, speed post tracking, financial services, or official government registrations).**

---

## 2. Information Sources & Data Provenance

In compliance with Google Play Developer policies regarding government information transparency, all postal directory information presented within this application is compiled from publicly accessible data repositories:

1. **Department of Posts, Ministry of Communications, Government of India**  
   - **Authority:** Official nodal agency for postal services, circles, and PIN code allocation in India.  
   - **Official Website:** [https://www.indiapost.gov.in](https://www.indiapost.gov.in)  
   - **Coverage:** Reference authority for postal circles, head offices, and nationwide postal hierarchy.

2. **Open Government Data (OGD) Platform India (`data.gov.in`)**  
   - **Dataset:** All India Pincode Directory published under the *Government Open Data License - India (GODL)*.  
   - **Official Portal:** [https://data.gov.in](https://data.gov.in)  
   - **Coverage:** Publicly released dataset of PIN codes, post office names, administrative districts, and postal circles.

3. **Postal PIN Code API (`api.postalpincode.in`)**  
   - **Service:** Public community REST API aggregating open postal data for directory lookups.  
   - **Service Endpoint:** [https://api.postalpincode.in](https://api.postalpincode.in)  
   - **Field Coverage:** Post Office Name, PIN Code, Branch Type (`HO` / `SO` / `BO`), Delivery Status (`Delivery` / `Non-Delivery`), District, Division, Region, Circle, Taluk/Block, and State.

4. **Department of Posts Sortation Hub Directory**  
   - **Dataset:** Catchment parcel routing and sortation plan master schema.  
   - **Coverage:** Routing PIN code ranges (`From Pin` – `To Pin`), Level 1 Parcel Hubs (L1), Level 2 Parcel Hubs (L2), National Sorting Hubs (NSH), and Intra-Circle Hubs (ICH).

> **Verification Notice:** Data within this application is compiled for convenience and reference purposes only. Individual records are not individually certified or officially verified by India Post. Users seeking authoritative postal bookings or government services should visit the official Department of Posts portal at [https://www.indiapost.gov.in](https://www.indiapost.gov.in).

---

## 3. Information We Collect

### A. Personal Information
The **India Post Offices** application does **not** require account creation, registration, or sign-in. We do **NOT** collect, transmit, store, or sell any personal information, including:
- Names, email addresses, or phone numbers
- Physical postal or street addresses
- Government identity numbers (Aadhaar, PAN, Voter ID, etc.)
- Bank details, payment cards, or financial credentials

### B. Location Data
The app does **not** access, request, or track your device's GPS or precise location.

### C. Technical & Diagnostic Information
The app may automatically receive limited non-personally identifiable technical diagnostic data strictly necessary for app stability and performance:
- Device model and manufacturer
- Operating system version (Android / iOS)
- Application version and build number
- Crash logs and performance diagnostics (via Google Play Console)

---

## 4. Advertisements (Google AdMob)

The application displays advertisements provided by **Google AdMob** to support maintenance and ongoing development.

Google AdMob may collect and process pseudonymous identifiers and device metrics, including:
- Google Advertising ID (GAID) / Identifier for Advertisers (IDFA)
- Device model, operating system, and hardware identifiers
- Approximate (network-level) location
- Ad interaction and performance events

This data collection is managed directly by Google under Google's Privacy Policies:
- **Google Privacy Policy:** [https://policies.google.com/privacy](https://policies.google.com/privacy)
- **Google AdMob Support & Data Practices:** [https://support.google.com/admob/answer/6128543](https://support.google.com/admob/answer/6128543)

---

## 5. Local Storage & Offline Usage

- **Local Storage:** User preferences (such as selected color themes and recent search caching) are stored exclusively in the private app sandbox on your device using `SharedPreferences`.
- **No Cloud Account Storage:** We do not maintain user databases or upload your search queries to external private servers. Search results are cached locally on your device to facilitate rapid offline lookups.

---

## 6. Permissions

The application requests only minimal, standard system permissions:
- **`android.permission.INTERNET`**: Required to query the postal directory API, fetch app updates, and display advertisements.
- **`android.permission.ACCESS_NETWORK_STATE`**: Required to check network connectivity before dispatching network requests.

---

## 7. Children's Privacy

The application is designed for a general audience and is completely family-safe. We do not knowingly collect or solicit personal data from children under the age of 13. If you believe any personal data has inadvertently reached us, please contact us immediately for deletion.

---

## 8. Third-Party Services

The application integrates the following third-party libraries and SDKs:
- **Google Play Services** (Core functionality and app delivery)
- **Google AdMob SDK** (Ad monetization)
- **Flutter & Dart Packages** (`shared_preferences`, `url_launcher`, `share_plus`, `flutter_tts`, `excel`)

Each third-party provider operates under its respective privacy terms and compliance standards.

---

## 9. Changes to This Privacy Policy

We may periodically revise this Privacy Policy to reflect changes in our practices or relevant regulatory requirements. Any updates will be committed to the official repository at:  
[https://github.com/Lokanath862001/India-Post-Offices/blob/main/PRIVACY_POLICY.md](https://github.com/Lokanath862001/India-Post-Offices/blob/main/PRIVACY_POLICY.md)  
with an updated Effective Date.

---

## 10. Contact Us

If you have questions, feedback, or concerns regarding this Privacy Policy or the application, please contact:

**Developer:** Shree Lakshmi Ventures  
**Contact Email:** `madhusmita852011@gmail.com`  
**GitHub Repository:** [https://github.com/Lokanath862001/India-Post-Offices](https://github.com/Lokanath862001/India-Post-Offices)  
