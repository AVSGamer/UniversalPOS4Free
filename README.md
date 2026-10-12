# 🏪 UniversalPOS4Free

**UniversalPOS4Free** is a fully open-source, highly adaptable **Point of Sale (POS) system** designed to serve any business vertical—from small retail shops to complex hospitality and decentralized web3-forward micro-economies.

---

## 🚀 Target Platforms & Roadmap

The software is systemically architected to compile across the following deployment targets:
* **🌐 Web Version** — Cloud-hosted or local intranet in-browser dashboard matrices.
* **🤖 Android App** — Mobile point-of-sale capabilities for handheld and tablet systems.
* **🐧 Linux Version** — Ultra-stable, low-overhead deployments optimized for dedicated hardware terminals.
* **🪟 Windows Version** — Native desktop enterprise integration using modular device connection architectures.
* **🍏 macOS Version** — *Conditionally planned pending community sponsorship or strategic open-source developer backing.*

---

## ⚙️ Initial System Configuration Matrix (`if firstRun`)

When the system triggers its `firstRun == 0` validation flag, it initializes a step-by-step setup wizard to configure baseline parameters.

### 🏢 1. Compliance & Business Profiles
* **Fiscalization Routing Mode:**
  * `0 (Omitted Mode)`: System bypasses internal registry forms; outputs a direct dialog stating document inputs for registration are omitted.
  * `1 (Compliance Mode)`: Renders user-customizable schema fields mapping to all data types returned by local business registries.
* **Metadata Profile:** Name, Registration Number, Validity/Expiration Window, Logo (BLOB/Vector path), Base Location Coordinates, unique Branch Code, and an array of `currenciesHandled`.

### 🔌 2. Hardware Driver Layer
Abstraction layers replacing legacy `.NET ODBC` implementations with generic cross-platform device handlers:
* **BarCode & QR Scanners** — Double-intent architecture supporting standard *Product SKU scanning*, *Administrative/Customer ID scanning*, *Crypto Wallet Public Address scanning*, and *Generation of Custom Product Codes QR or Bar for New Products or Store-Specific Coding*.
* **Thermal Printers** — Emits dynamically structured tickets\invoice\receipt\reports mapped against `Receipt Size Standard`, `Business Details`, `Product Details`, `Location Based Language`, `Print Copy Number`, and `Traceable Transaction Identifier` sequences (includes native graphic processing for transaction confirmation QR codes).
* **Cash Register Drawer** — Pulse-triggered electronic kick-pin configurations.
* **Customer Notification Devices** — Native integration support for physical short-range coaster pagers. Optional SMS(Requires an API and/to a SIM or eSIM that will send the SMS) or Email Notification(Requires an Email Server/Sender) with possible optional service fee charge if so. And possible API Integration with other Online Platforms.

### 🪙 3. Cryptocurrency Integration Engine
A built-in payment pipeline allowing non-custodial decentralized processing without relying on expensive middleman payment processors:
* **Supported Core Assets:** Bitcoin (BTC), Ethereum (ETH), Stablecoins (USDT/USDC via multi-chain layers like Polygon, Solana, or Arbitrum), and regional Layer-1 chains.
* **Network & RPC Node Customization:** Admins configure remote RPC nodes or local self-hosted nodes directly through the core communication interface using customizable endpoint routing parameters:
  * `Gateway/RPC URL`, `Port`, `WebSocket vs HTTP protocols`, and custom `Payload Formats`.
* **Dynamic Exchange Parsing:** Integrates real-time price feed API hooks to automatically calculate the local currency equivalent against crypto spot rates at the exact millisecond of checkout.
* **On-Screen QR Compilation:** Automatically generates dynamic payment QR codes on the customer-facing display or receipt terminal containing:
  * `Merchant Public Address` + `Exact Crypto Amount requested` + `Unique Transaction ID String`.

### 👤 4. Dynamic Account Hierarchy & Logging Matrix
Accounts support dynamic index allocation allowing an infinite tiering of roles. Permission verification logic validates all context jumps to intercept privilege escalation attempts.

* **Default Dynamic Tier Privileges:**
  * **Admin (`Level 0`)**: Unrestricted log access (including crypto transaction hashes and public address configurations), dynamic user creation/deletion, arbitrary button/menu visibility maps, regional language translations/label overrides, absolute layout adjustment tools, currency bill/coin physical metric variables, and mandatory system startup interception flags.
  * **Supervisor (`Level 1`)**: Privilege verification gateway, view and print system reports, trigger transactional `void` logic.
  * **Cashier (`Level 2`)**: Execute drawer manipulation commands (`open/close`), perform point-of-sale checkouts, process fiat payments, parse change, and visually confirm crypto tx status blocks via the ledger UI.

### 📦 5. Multi-Tier Inventory & Tracking Engine
* **Physical Asset Fields:** Product Photo, Category Aisle ID, Sub-Category Section ID, True Name, Brand, Supplier Meta (Company, Contact Name, Direct Line/Number), and Restock Iteration Loops (`Daily | Weekly | Monthly`).
* **Pre-Order Execution Flags:** Tracks variable lead timelines: `expectedArrival` ➡️ `actualArrival` ➡️ `deliveredToBuyer` ➡️ `dateDeliveredToBuyer`. Includes buyer platform hooks, direct contact numbers, and delivery distribution tracking:
  * *In-house Fleet* vs. *Outsourced Couriers* (Customizable integration templates for localized solutions like J&T, Lalamove, etc.).
* **Barcode Mapping Engine:** Toggle default product identifiers or systematically compute unique store-specific translation arrays (`StoreBarCodes` / `StoreQRCodes`) for inventory tracking without manufacturer labels. Contains integrated analytics charts for historical `productStatistics`.

### 🏷️ 6. Discount Systems & API Extensibility
Dual-engine allocation logic running localized **FLAT** or **PERCENTAGE** deductions, paired with an API configuration panel enabling custom network routing parameters (`IPAddress/GatewayURL`, `PORT`, `PacketType`, and `Format`) to ping remote verification systems.
* **Pre-Built Profiles:** Person with Disability (PWD), Senior Citizen, Student, Internal Employee.
* **Custom Engine:** Admins can dynamically engineer proprietary promotional rules and temporary marketing matrices.

---

## 🔁 Daily Operational Workflow Logic

### 🌅 Phase 1: Opening Daily Operations
1. **Initialize Starting Ledger:** Capture starting bank amount for daily change workflows. Open cash drawer for visual denomination verification.
2. **Prioritization Rules:** Parse algorithm constraints specifying change distribution rules: `Bigger Denominations First` 🔄 `Smaller Denominations First` 🔄 `Lesser Weight Change First`.
3. **Inventory Audit Check:** Run system query asking for pending stock arrivals or immediate supply shifts.
4. **Startup Evaluation Intercept:** If setting flag `supervisorOrAdminAlwaysStartsSystem == Y`, fetch previous day's end-of-day profit metrics (fiat revenue + crypto balance totals) before unlocking the sales floor.

### 💸 Phase 2: Processing Transactions
1. **Itemization:** Format item text boundaries dynamically to prevent string overflows on configured thermal receipt widths.
2. **Payment Processing Choice:** If the user selects **Cryptocurrency**:
   * The terminal pings the configured exchange API, calculates the rate, presents the target QR code, and continuously listens to the blockchain mempool via RPC WebSockets until the transaction hash maps to `Success` state.
3. **Privilege Boundary Invalidation:** If a transaction requires an operational `void`, a security intercept halts the pipeline until a user token possessing `voidTransactions` capabilities is explicitly scanned or inputted.
4. **Food & Beverage (F&B) State Flow:** 
   \[\text{Generate Order # for the Day} \longrightarrow \text{Preparing State} \longrightarrow \text{Order Status State} \longrightarrow \text{Ready for Pick-Up} \longrightarrow \text{Trigger Pager (2.4G)}\]

### 🌃 Phase 3: Shift Logout & Closing Procedures
1. **Cash Drawer Balancing:** Authenticated account holders execute manual cash balance pulls and log processed wallet distributions.
2. **Report Compilation:** Generate localized performance metrics separating fiat earnings, card processing totals, and specific cryptocurrency asset volume.
3. **EOD Evaluation:** Parse current settings schemas to verify if active operators are permitted to display end-of-shift net profits directly on the terminal monitor.

---

## ⚖️ Legal & Compliance Disclaimer

### 📋 Commercial Compliance
* **Business Registration & Crypto Taxation:** All legal registrations, tax authority connections, capital gains calculations, and compliance with local cryptocurrency commercial asset frameworks remain completely under the independent control and structural liability of the end-user.

### ⚠️ Liability Waiver
* **No Liability:** This framework is provided entirely "as is", without warranty of any kind. The core authors, maintainers, and contributors accept **no liability** for any legal non-compliance, market volatility, wallet exploits, unconfirmed blockchain transactions, or financial shortfalls resulting from configuration deployment.
