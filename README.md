# Event Manager

Event Manager is a Ruby program designed to process event attendee data from a CSV file. The program cleans and validates data, performs analysis on registration times, fetches legislative representatives based on zip codes, and generates personalized thank-you letters for each attendee.

## Features

- **Zip Code Normalization**: Ensures zip codes are always 5 digits, padding with zeros if necessary.
- **Phone Number Cleaning**: Formats and validates phone numbers.
- **Registration Analysis**: Analyzes and counts registrations by hour and day.
- **Legislator Lookup**: Retrieves legislative representatives using the Google Civic Information API.
- **Thank You Letter Generation**: Creates personalized thank-you letters in HTML format.

## Prerequisites

To run this program, ensure you have:

- Ruby (version 2.7 or higher)
- A valid API key for the [Google Civic Information API](https://developers.google.com/civic-information/docs/using_api)
- The following files in the working directory:
  - `event_attendees.csv`: The input CSV file containing attendee data.
  - `form_letter.erb`: An ERB template for the thank-you letter.
  - `secret.key`: A file containing your Google Civic Information API key.

## Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/your-username/event_manager.git
   cd event_manager
   ```

2. Install the required Ruby gems:
   ```bash
   bundle install
   ```

3. Add your Google Civic Information API key to a file named `secret.key` (one line only).

## Usage

Run the program with:

```bash
ruby event_manager.rb
```

### Input CSV Format
The `event_attendees.csv` file should have the following structure:

| id  | first_name | last_name | zipcode | homephone | regdate          |
|-----|------------|-----------|---------|-----------|------------------|
| 1   | John       | Doe       | 12345   | 123-456-7890 | 11/12/08 10:47 |
| ... | ...        | ...       | ...     | ...       | ...              |

### Output

- **Personalized Thank-You Letters**: Saved as individual HTML files in the `output` directory (e.g., `output/thanks_1.html`).
- **Registration Statistics**: Displays registration counts by hour and day in the console.

## Code Overview

### Key Methods

- **`clean_zipcode(zipcode)`**
  - Ensures zip codes are 5 digits long, padding with zeros if necessary.

- **`legislators_by_zipcode(zip)`**
  - Fetches legislative representatives based on the given zip code using the Google Civic Information API.

- **`save_thank_you_letter(id, form_letter)`**
  - Saves personalized thank-you letters as HTML files.

- **`clean_phone_numbers(number)`**
  - Removes non-digit characters from phone numbers.

- **`format_number(number)`**
  - Formats valid phone numbers as `(XXX) XXX-XXXX`.

- **`check_phone_numbers(number)`**
  - Validates phone numbers, ensuring they are either 10 digits or start with `1`.

- **`count_registration_hours(date)`**
  - Counts registrations grouped by the hour.

- **`count_registration_days(date)`**
  - Counts registrations grouped by the day of the month.

### Dependencies

- `google-apis-civicinfo_v2`: For retrieving legislator information.
- `csv`: For processing CSV files.
- `erb`: For generating personalized thank-you letters.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Contributing

Pull requests are welcome! For major changes, please open an issue first to discuss what you would like to change.

---

Happy coding!
