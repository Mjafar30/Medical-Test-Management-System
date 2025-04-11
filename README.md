# Medical Test Management System (MIPS Assembly)

## Objective
This project is a Medical Test Management System developed in MIPS Assembly Language.
It acts as a simple patient record system that stores, manages, and retrieves medical test results for patients.

## File Format
Each line in the text file represents one medical test in the format:
<PatientID>: <TestName>, <TestDate>, <Result>

Example:

1300500: RBC, 2024-03, 13.5  
1300511: LDL, 2024-03, 110

Fields:
- Patient ID: 7-digit integer
- Test Name: Fixed-length string
- Test Date: YYYY-MM format
- Result: Floating-point number

## Supported Medical Tests and Normal Ranges
1. Hemoglobin (Hgb): 13.8 to 17.2 g/dL  
2. Blood Glucose Test (BGT): 70 to 99 mg/dL  
3. LDL Cholesterol (LDL): Less than 100 mg/dL  
4. Blood Pressure Test (BPT):  
   - Systolic < 120 mm Hg  
   - Diastolic < 80 mm Hg

## System Functionalities
- Add a new medical test  
- Search by patient ID:  
  • Retrieve all tests  
  • Retrieve abnormal tests  
  • Retrieve tests for a specific period  
- Search for abnormal test results by test type  
- Calculate average value for each test  
- Update an existing test result  
- Delete a test entry  

## Error Handling
- Invalid input formats  
- Incorrect date format (must be YYYY-MM)  
- Out-of-range test values  
- File not found  
- Patient or test not found  

## Data Validation
- Patient ID must be a 7-digit number  
- Date must follow YYYY-MM format  
- Month must be between 01 and 12  
- Result must be a valid floating-point number  
- Checks are implemented before processing each input

## How to Use
1. Open the `.asm` file using a MIPS simulator like MARS.
2. Run the program.
3. Follow the menu instructions displayed in the console.
4. Enter the required inputs for each option.
5. The system reads from and writes to a text file for storing test data.

## Files
- Project.asm: Main program logic and menu
- MedicalTests.txt: Medical test records file
- 


