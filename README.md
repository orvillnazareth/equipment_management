# Equipment Management System

This Equipment Management System is a Shiny web application designed to facilitate the process of borrowing and managing equipment within an organization. The application enables users to select equipment, log transactions, verify user details, and submit transaction records to a centralized Google Sheet for efficient tracking.

## Purpose and Features

The primary purpose of this application is to streamline equipment management and ensure that all transactions are verified and logged accurately. The app includes several key features:

- **User Authentication**: The app requires users to log in securely, ensuring that only authorized personnel can access the system.
  
- **Equipment Selection and Logging**: Users can browse available equipment, select items to borrow, and review the transaction log within the app. This ensures that all equipment movements are tracked and documented.

- **Simplified Return Process**: To simplify the process of returning equipment, the app treats equipment return as a special case of issuing. When equipment is returned, it is "issued" to the curator, and can be verified by the user. This streamlined approach bypasses the need for a separate return process, while still ensuring that all equipment movements are properly logged and verified.

- **Verification and Submission**: A second-party verification process ensures that transactions are validated before being submitted to the Google Sheet. The verifier’s name and pin must match the stored credentials for the transaction to be processed. This step adds an extra layer of accountability.

- **Automated Data Submission**: Once verified, the transaction details—including the user name, verifier name, date, and time—are automatically submitted to a Google Sheet for record-keeping. This integration with Google Sheets allows for centralized tracking and easy access to historical data.

- **Session Reset**: After successful submission, users are prompted to log out, ensuring that each session is treated independently. This reduces the risk of errors or duplicate entries and makes sure that the app is ready for the next user.

## Setup Instructions

To use this application, you will need to set up the following Google Sheets:

1. **Login Sheet**: Replace `link-to-your-google-sheet-with-login-information` with the link to your Google Sheet that contains user credentials for authentication.
2. **Equipment Sheet**: Replace `link-to-your-google-sheet-with-equipment-information` with the link to your Google Sheet that lists available equipment.
3. **Submission Sheet**: Replace `link-to-your-google-sheet-for-submissions` with the link to your Google Sheet that stores the transaction logs submitted after verification.

## Contributing

Contributions to improve this app are welcome! Whether it's adding new features or refining existing ones, your input helps make this tool better for everyone.

## License

This project is licensed under the MIT License. See the LICENSE file for more details.
