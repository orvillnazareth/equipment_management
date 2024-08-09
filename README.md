Equipment Management System
This Equipment Management System is a Shiny web application designed to facilitate the process of borrowing and managing equipment within an organization. The application enables users to select equipment, log transactions, verify user details, and submit transaction records to a centralized Google Sheet for efficient tracking.

Purpose and Features
The primary purpose of this application is to streamline equipment management and ensure that all transactions are verified and logged accurately. The app includes several key features:

User Authentication: The app requires users to log in securely, ensuring that only authorized personnel can access the system.
Equipment Selection and Logging: Users can browse available equipment, select items to borrow, and review the transaction log within the app.
Verification and Submission: A second-party verification process ensures that transactions are validated before being submitted to the Google Sheet. This ensures accountability and accurate record-keeping.
Automated Data Submission: Once verified, the transaction details, including the user name, verifier name, date, and time, are automatically submitted to a Google Sheet for record-keeping.
Session Reset: After successful submission, users are prompted to log out, ensuring that each session is treated independently, reducing the risk of errors or duplicate entries.
Setup Instructions
To use this application, you will need to set up the following Google Sheets:

Login Sheet: Replace link-to-your-google-sheet-with-login-information with the link to your Google Sheet that contains user credentials for authentication.
Equipment Sheet: Replace link-to-your-google-sheet-with-equipment-information with the link to your Google Sheet that lists available equipment.
Submission Sheet: Replace link-to-your-google-sheet-for-submissions with the link to your Google Sheet that stores the transaction logs submitted after verification.
Contributing
Contributions to improve this app are welcome! Whether it's adding new features or refining existing ones, your input helps make this tool better for everyone.

License
This project is licensed under the MIT License. See the LICENSE file for more details.
