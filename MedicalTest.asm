### DONE BY: ###
### TALEEN ABUZULOUF ###### MAYAR JAFAR  ##### 
###   1211061        ######   1210582  ######
### Section "1" ###

.data

### ARRAYS ###
   Patient_ID: .word  0:100      # array of integers
   Test_Name:  .word  0:100      # array of addresses of name strings
   Date:       .word  0:100      # array of addresses of date strings
   Result:     .word 0:100       # array of adresses of float results
   Index_list: .space 48         # array that containes indicies for a specific id search



### global size parameters and string spaces ###
   current_size:   .word 0:1     # current size of all arrays
   ID_size:        .word 4:1     # 4 bytes for each ID
   testname_size:  .word 4:1     # 4 bytes each test name
   date_size:      .word 8:1     # the size of each date
   result_size:    .word 20:1     # the size for each result(max)
   globalarray_size: .word 4:1   # the size of each element in all arrays (Patient_ID,Test_Name,Date,Result)

   str: .space 100 # used as an input buffer when reading a test name string
   dt:  .space 100 # used as an input buffer when reading a date string
   flt: .space 2000 # used as an input buffer when reading a float as a result
   
   
### search related parameters ###
   string: .space 10         # used to get the intended test by user
   date: .space 10

   
   
### All valid Medical tests names ###
   Hgb_name: .asciiz "Hgb"   # hemoglobin test
   BGT_name: .asciiz "BGT"   # blood glucose test
   LDL_name: .asciiz "LDL"   # Cholestrol low-Density Lipoprotein test
   BPS_name: .asciiz "BPS"   # Systolic Blood pressure test
   BPD_name: .asciiz "BPD"   # Diastolic Blood pressure test
   
   
### Medical tests ranges ###
   Hgb_lower: .float 13.8:1 # lower range of Hgb test
   Hgb_upper: .float 17.2:1 # upper range of Hgb test
   BGT_lower: .float 70.0:1 # lower range of BGT test
   BGT_upper: .float 99.0:1 # upper range of BGT test
   LDL_upper: .float 100:1  # upper range of LDL test
   BPD_upper: .float 80.0:1 # lower range of BPD test
   BPS_upper: .float 120:1  # upper range of BPS test
   
   
### Global Constants ###
   decimalvalue: .float 0.1  # used to store the float number 0.1
   
   
### file parameters ###   
   fileName:     .asciiz "C:/Users/hp/Desktop/Arch/MedicalTests.txt"
   fileWords:    .space 1000             #string that will hold all the words in the file 
   fileError:    .asciiz  "...ERROR encountered...file cannot be opened!\n"
   fileString:   .space 1000            # string that will be written on file
   
### Data Validation and Error handling parameters ###
   choice:  .space 2     # only two byte, to limit the user to enter one character only
   ID_str:   .space 8    # to limit the numbers of id digits
   name_str: .space 4   # to limit the number of characters 


### Prompts and Menu ###
   menu:    .asciiz "\nMedical Test Management System\n 1. Add a new test\n 2. Search for a test by patient ID\n 3. Delete a test\n 4. Update test results\n 5. Print all tests\n 6. Search upnormal tests of a specific test\n 7. Print the average test value of a specific test\n 8. Exit"
   prompt:  .asciiz "\nEnter your choice: "
   invalid_input: .asciiz "\nInvalid input. Please try again.\n"
   addtest_ID_prompt: .asciiz "\nEnter patient ID\n "
   addtest_name_prompt: .asciiz "\nEnter test name\n "
   addtest_date_prompt: .asciiz "\nEnter test date\n "
   addtest_result_prompt: .asciiz "\nEnter test result\n "
   delete_prompt: .asciiz "\n    Medical test has been deleted !\n"
   delete_error_prompt: .asciiz "\n    ERROR! : Medical test does not exist !\n"
   search_menu: .asciiz "\n 1-Retrieve all patient tests\n 2-Retrieve all up normal patient tests\n 3-Retrieve all patient tests in a given specific period\n"
   search_id_error_prompt: .asciiz "\n    ERROR! : Patient ID is not found !\n"
   testname_error_prompt: .asciiz "\n   ERROR! : unrecognizable test name!\n"
   specific_date: .asciiz "\nEnter specific period:\n"  
   Display_Test_Name: .asciiz "Test Name :  "
   Display_Test_Result: .asciiz "\nTest Result : "
   Display_Test_Date: .asciiz "Test Date : "
   search_period_error: .asciiz "No Tests found in the given period ! \n"
   average_value_prompt: .asciiz "\nthe average value of given test:\n"
   Display_average_result: .asciiz " Average test result: "
   BPT_prompt: .asciiz "\n  which test of blood pressure test do you want to evaluate:\n  1- Systolic Blood Pressure\n  2- Diastolic Blood Pressure\n"
   update_result: .asciiz "Enter the new result \n"
   update_message: .asciiz "Updated the new result successfully ! \n"
   From_date: .asciiz "\nEnter first date:\n"
   To_date: .asciiz "\nEnter second date:\n"
   ID_invalid_prompt: .asciiz "\n invalid ID\n"
   result_invalid_prompt: .asciiz "\n invalid test result\n"
   Test: .asciiz"Test record: "
   error_date_format: .asciiz "\nDate format is incorrect make sure writing date in the correct format (yyyy-mm) "
   error_month: .asciiz "\n Invalid  Month !\n"
   error_year: .asciiz "\n Invalid Year !\n"
   error_range: .asciiz "\n invalid range\n"




.text
#########################################################################################################################################
#                                                                 READ FROM FILE                                                        #
#########################################################################################################################################


	# Open file
	li $v0 , 13                    # Open file syscall code = 13
	la $a0 , fileName              # get the file name
	li $a1 ,0                      # file flag = read (0)
	syscall
	move $s0 , $v0                 # save the file descriptor. $s0 = file
	
	# print an error message 
	bge $v0, 0, continue
	li $v0, 4
        la $a0, fileError
        syscall
        j exit
	
        continue:	
        
	# Read file 
	li $v0,14                      # Read file
	move $a0,$s0                   # file descriptor (we use it to identify which file is being read)
	la $a1,fileWords               # The buffer that holds the string of the WHOLE file
	la $a2,1024                    # buffer length
	syscall
	

	move $s7,$v0                   # Save the number of charachters read
	
	
	# Close the file (imporatnt)
	li $v0 , 16                    # close file
	move $a0 , $s0                 # file descriptor to close
	syscall
	
	j splitData                    # go to function that rearranges the file content into arrays



#########################################################################################################################################
#                                                                      MAIN                                                             #
#########################################################################################################################################

	
main:


    # Display menu
    li $v0, 4
    la $a0, menu
    syscall

    # Prompt user for input
    li $v0, 4
    la $a0, prompt
    syscall

    # Read user input(in string form!)
    li $v0, 8
    la $a0,choice                          # address of buffer choice
    li $a1,2                               # to limit the number of characters read
    syscall
    
    jal check_integer_choice               # check if the input choice is an integer
    move $t0,$v1                           # Store user input in $t0


    # Process user input
    beq $t0, 1, add_test                   # If user input is 1, go to add_test
    beq $t0, 2, Search                     # If user input is 2, go to search
    beq $t0, 3  delete_test                # if user input is 3, go to delete_test
    beq $t0, 4, Update_Results             # If user input is 4, update
    beq $t0, 5, printall                   # If user input is 5, print all tests
    beq $t0, 6, display_upnormal_tests     # If user input is 6, print all upnormal tests of a specific test
    beq $t0, 7, find_average_testresult    # If user input is 7, print the average test result 
    beq $t0, 8, exit                       # If user input is 8, exit 
    
    invalid_input_format:
    # Invalid input
    li $v0, 4
    la $a0, invalid_input
    syscall
    j main # Restart the main loop


#########################################################################################################################################
#                                                                    ADD NEW TEST                                                       #
#########################################################################################################################################



add_test:

   lw $t0,current_size                           # counter
   
   add_ID:
   ### Read ID 
   li $v0, 4                                     # print string prompt
   la $a0,addtest_ID_prompt
   syscall
   
   li $v0,8
   la $a0,ID_str
   addi $a1,$zero,8                                      # read integer
   syscall
   
   move $s0,$a0                                 # checking the ID format
   jal check_ID_format
   beq $v1,-1,not_valid1
   j valid1
   
   not_valid1:
   li $v0, 4                                     # print string prompt
   la $a0,ID_invalid_prompt
   syscall
   j add_ID
   
   valid1:
   ### store integer in array
   addi $t1,$zero,0                              # reset register
   lw $t1,ID_size                                # load the size od each ID
   mul $t1,$t1,$t0                               # offset for patient id array = current_overall_size + the size for_each_ID 
   sw $v1,Patient_ID($t1)                        # store integer into address of label patient id
   
   
   
   ### Read test name and store in array ###
   add_name:
   li $v0, 4                                     # print string prompt
   la $a0,addtest_name_prompt
   syscall
   
   addi $t1,$zero,0                              # rests register
   lw $t1,testname_size                          # load the size of each name
   mul $t1,$t1,$t0                               # offset for Test_Name array = current_overall_size + the size for_each_name
   
   li $v0,8                                      # read string
   la $a0,str($t1)                               # input buffer  changed every time a string is read from user
   li $a1,4                                      # max chracters to read
   syscall
   
   move $s0,$a0                                  # move the address to s0, to check the format
   jal check_name_format
   
   bne $v1,-1,valid3
   la $a0,testname_error_prompt                  # print error test name
   li $v0,4
   syscall
   j add_name
   
   valid3:
   sw $a0,Test_Name($t1)                         # this store the address of the string in the array(Test_Name is an array of addresses of strings)
   
   
   ### Read test date and store in array ###
   enter_again:
   li $v0, 4 #print string prompt
   la $a0,addtest_date_prompt
   syscall
   
   
   addi $t1,$zero,0 # rests register
   lw $t1,date_size #load the size of each date
   mul $t1,$t1,$t0 # offset for dt buffer = current_overall_size + the size for_each_date string
   
   li $v0,8 #read string
   la $a0,dt($t1) #input buffer  changed every time a string is read from user
   li $a1,8 #max chracters to read
   syscall
   
   move $t7,$a0   ## preserve the address of first byte of date string
   
   jal check_date_format 
   beq $v1 , -1 , enter_again
   
 
   
   addi $t1,$zero,0                              # rests register
   lw $t1,globalarray_size                       # load the global size of the date array (note that Date array is an array of addresses) 
   mul $t1,$t1,$t0                               # offset for Date array = current_overall_size + the size for_each_date
  
   sw $t7,Date($t1)                              # this store the address of the string in the array(Date is an array of addresses of strings)
   
   
   ## Read test result and store in array ###
   add_result:
   li $v0, 4                                     # print string prompt
   la $a0,addtest_result_prompt
   syscall
   
   addi $t1,$zero,0                              # rests register
   lw $t1,result_size                            # load the size of each result( max size =19 byte)
   mul $t1,$t1,$t0                               # offset for Reasult array = current_overall_size + the size for_each_result
   
   la $a0,flt($t1)                               # input buffer for string result
   li $a1,20                                     # max number of characters to read 
   li $v0,8                                      # read string result
   syscall
   
   move $s0,$a0                                  # pass the address of flt as an argument to function remove_newLine
   jal remove_newLine                            # remove the new line character from the end of string
   
   move $s0,$a0                                  # pass the address of flt as an argument to function cheack_float_format
   jal check_float_format                        # check the format of entered result by user
   bne $v1,-1,valid4
   
   la $a0,result_invalid_prompt                 # print error test result
   li $v0,4
   syscall
   j add_result
   
   valid4:
    addi $t1,$zero,0                              # rests register
   lw $t1,globalarray_size                       # load the global size of the date array (note that Date array is an array of addresses) 
   mul $t1,$t1,$t0                               # offset for Date array = current_overall_size + the size for_each_date
   sw $a0,Result($t1)                            # store the string result in the array "Result"
   
  
###### for all ARRAYS ######
   addi $t0,$t0,1                                # increment the size of all arrays (amount of test records)
   sw $t0, current_size                          # increment the global counter for the medical test size
   
   
    ### print new line
    jal newLine
    jal write_to_file
    
   j main                                        # Return to the main
   


#########################################################################################################################################
#                                                                 PRINT ALL TESTS                                                       #
#########################################################################################################################################
                                             
printall:

      ### print new line
      jal newLine
      
      lw $t0,current_size                        # get the current size of all tests
      add $t1,$zero,$zero                        # a counter to keep track of the printed elements
      addi $t2,$zero,0                           # to keep incrementing the offset for array
      
        printloop:

        bge $t1,$t0,main                         # break the loop if all elements have been printed
        
        ### print patient ID
        lw $t2,ID_size                           # size for each ID
        mul $t2,$t2,$t1                          # find offset depending on current loop iteration(counter in register $t1)
        
        lw $a0,Patient_ID($t2)                   # load the integer
        li $v0,1                                 # print integer
        syscall
        
        # print space
        jal space 
        
        ### print test name
        lw $t2,testname_size                     # size for each test name
        mul $t2,$t2,$t1                          # find offset depending on current loop iteration(counter in register $t1)
        
        lw $a0,Test_Name($t2)                    # load test mane
        li $v0,4                                 # print string
        syscall
        
        # print space
        jal space 
        
        ### print date
        lw $t2,globalarray_size                  # size for each test date
        mul $t2,$t2,$t1                          # find offset depending on current loop iteration(counter in register $t1)
        
        lw $a0,Date($t2)                         # load date
        li $v0,4                                 # print string
        syscall
        
        # print space
        jal space 
        
        ### print result
        lw $t2,globalarray_size                       # size for each result
        mul $t2,$t2,$t1                          # find offset depending on current loop iteration(counter in register $t1)
        
        lw $a0,Result($t2)                       # load the address of float
        li $v0,4                                 # print single precision float
        syscall
        
        ### print new line
        jal newLine
        
        ### go to next iteration
        addi $t1,$t1,1
        j printloop
        
        

      j main  
  

#########################################################################################################################################
#                                                                      FUNCTIONS                                                        #
#########################################################################################################################################
              
            
                                     #### function for printing a new line ####     
newLine:

        # syscall number for printing character (new line)
        li      $a0, 10                          # ascii code for new line : 10
        li      $v0, 11  
        syscall    
        jr $ra   

                                     ### function for printing a space ###
space:

        ### print space
        li      $a0, 32                          # ascii code for space : 32
        li      $v0, 11  
        syscall
        jr $ra
        
compare:
        ### the two strings are in s0 and s1, return value is in $v0
        ### return 1 if equal, else return zero
        
        lb $t2,($s0)                             # load the first character of first string
        lb $t3,($s1)                             # load the first character of the second string
        
        cmploop1:
        beq $t2,$zero,equal                      # if end of string has been reached, then both strings are equal
        bne $t2,$t3,notequal1
       
        addi $s0,$s0,1                           # increment address
        addi $s1,$s1,1                           # increment address
       
        lb $t2,($s0)                             # load the next character of first string
        lb $t3,($s1)                             # load the next character of the second string
       
        j cmploop1
   
        notequal1:                               # not equal return value 0
        li $v0,0                                 # return value 0
        jr $ra                                   # return 
       
        equal:                                   # tests are the same! return 1
        li $v0,1                                 # return the value 1
        jr $ra                                   # return
       
check_integer_choice:
         addi $v1,$zero,0
         lb $v1,choice
         blt $v1, '0', invalid_input_format      # exit loop if ($t1 < '0'), go to invalid_input label in main
         bgt $v1, '9', invalid_input_format      # exit loop if ($t1 > '9'), go to invalid_input label in main
         addiu $v1, $v1, -48                     # Convert character to digit
         jr $ra
        
check_ID_format: 
         ### address of string is in s0
         ### return vlaue is in $v1, if v1=-1 then invalid, else valid and the return value is the integer ID
         ### this function uses $s5,$s6
         addi $s6,$zero,0           # loop counter
         addi $v1,$zero,0           # return value
         check_ID_loop:
         lb $s5,($s0)          # load the next byte
         addi $s0,$s0,1        # increment the address
         addi $s6,$s6,1           # increment counter
         beq $s5,'\0',check_iteration    # if null is found, the iteration of loop must be checked to ensure 7 digits
         blt $s5,'0',invalid_PatientID  # if character is found that is not a number, then invalid case
         bgt $s5,'9',invalid_PatientID  # if character is found that is not a number, then invalid case
         addiu $s5,$s5,-48              # string to sigit
         mul $v1,$v1,10
         addu $v1,$v1,$s5              
         j check_ID_loop
         
         check_iteration:
         beq $s6,8,valid_PatientID   # all seven digits have been explored plus null char
         j  invalid_PatientID
         
         valid_PatientID: # return the parsed int in $v1 
         jr $ra
         invalid_PatientID:
         li $v1,-1
         jr $ra

check_name_format:
         ### address of string is in s0
         ### return vlaue is in $v1, if v1= -1 then invali, else valid
         ### registers used: $a3,$s6
         move $a3,$ra   # preserve the return address
         move $s6,$s0   # preserve the address of entered string
         
         #Hgb
         la $s1,Hgb_name            # get the address of name of Hgb test
         jal compare                # begin compareson
         beq $v0,1,valid_name      # if they match, then a valid test name
       
         #BGT
         move $s0,$s6            # get back to the original address
         la $s1,BGT_name         # get the address of name of BGT test
         jal compare                # begin compareson
         beq $v0,1,valid_name      # if they match, then a valid test name
       
         #LDL
         move $s0,$s6            # get back to the original address
         la $s1,LDL_name         # get the address of name of LDL test
         jal compare                 # begin compareson
         beq $v0,1,valid_name      # if they match, then a valid test name
       
         #BPD:
         move $s0,$s6            # get back to the original address
         la $s1,BPD_name         # get the address of name of BPD test
         jal compare                 # begin compareson
         beq $v0,1,valid_name      # if they match, then a valid test name
       
         #BPS:
         move $s0,$s6            # get back to the original address
         la $s1,BPS_name         # get the address of name of BPS test
         jal compare                 # begin compareson
         beq $v0,1,valid_name      # if they match, then a valid test name
         
         invalid_name:
         addi $v1,$zero,-1              # return value
         move $ra,$a3                   # load the return address of this function
         jr $ra
         
         valid_name:
         addi $v1,$zero,1              # return value
         move $ra,$a3                  # load the return address of this function
         jr $ra
       
         

check_date_format :
    ####### address of string is in $a0
    ####### return value is in $v1, -1 for invalid, else valid
     
    addi $v1,$zero,0 	#Flag
    addi $s0,$zero,0
    addi $s1,$zero,0
    
    move $a3 , $ra	#to preserve the address
   
     # Check format
    lb $v1, 4($a0)      # Check character at index 4
    bne $v1, '-', input_error 
    
       
     jal split_date      # returns  the year in s0 and the month in s1
     bge $s0 , 2025 , wrong_year
     ble $s0 , 0 , wrong_month
     bgt $s1 , 12 , wrong_month
     ble $s1 , 0 , wrong_month
     
     move $ra , $a3
     jr $ra
      
       
    input_error:
    # Display error message and handle invalid input
    li $v0, 4
    la $a0, error_date_format
    syscall
    
    li $v1,-1
    move $ra , $a3	#to preserve the address
    jr $ra
       
        
          
    wrong_month:
     # Display error message and handle invalid month
    li $v0, 4
    la $a0, error_month
    syscall
    li $v1,-1
    move $ra , $a3	#to preserve the address
    jr $ra
          
   
    wrong_year:
    li $v0, 4
    la $a0, error_year
    syscall
    li $v1,-1
    move $ra , $a3	#to preserve the address
    jr $ra 
    

         
check_float_format:
         ### address of string wil br pased through register $s0
         ### the return value will be in $v1, if v1= -1, then the float is not valid, else valid
         ### registers used: 
         addi $v1,$zero,0         #reset
         
         check_float_loop:
         lb $v1,($s0)              # load the first character
         addi $s0,$s0,1            # increment address
         beq $v1,'\0',valid_result
         beq $v1,'.',decimal_point_found    # check for decimal point
         blt $v1,'0',invalid_result         # check for non-digit characters
         bgt $v1,'9', invalid_result        # check for non-digit characters
         j check_float_loop
         
         decimal_point_found:
         addi $s6,$zero,0  # counter for rounding (geeting only two digits after decimal point)
         
         decimal_digits_loop:
         beq $s6,2,round            # if more than two digits exist after point, then round them
         addi $s6,$s6,1           # incrememnt counter
         lb $v1,($s0)
         addi $s0,$s0,1             # increment address
         beq $v1,'\0',valid_result
         blt $v1,'0',invalid_result         # check for non-digit characters
         bgt $v1,'9', invalid_result        # check for non-digit characters
         j decimal_digits_loop
         
         round:
         subi $s0,$s0,1         # go back to the second digit address after the decimal point
         addi $s0,$s0,1        # increment address
         lb $v1,($s0)
         beq $v1,'\0',valid_result          # check for end of float    
         blt $v1,'0',invalid_result         # check for non-digit characters
         bgt $v1,'9', invalid_result        # check for non-digit characters
        
        
         li $v1,'\0'                       # round the to floor value
         sb $v1,($s0)                      # cutt off the string
         j valid_result
     
         
         valid_result:      # valid test result
         addi $v1,$zero,1
         jr $ra
         invalid_result:    # invalid input test result
         addi $v1,$zero,-1
         jr $ra
         
         
         
    
convert_to_float:
        # function takes the address of first byte of string result and returns the string to float converted number
        # address of first byte must be in $s0, return value in $f0
        # note that this function uses $v0,$t8,$2,$f3,$f5 in calculation
        
        addi $v0,$zero,0                         # reset
        addi $t8,$zero,0                         # to keep track of integer sum
        mtc1 $zero,$f0                           # reset  
        
        floatloop1:
        lb $v0, ($s0)                            # load next byte
        addi $s0,$s0,1                           # increment address
        
        beq $v0,'.',decimal                      #decimal point is found!
        beq $v0,'\0',floatdone1                  # end of record is reached(no decimal value is found, still number is concedered as float)
        
        ## string to integer parsing
        addiu $v0,$v0,-48                        #convert the string to integer
        mul $t8,$t8,10                           #sum=sum*10
        add $t8,$t8,$v0                          #sum=sum+digit
        j floatloop1
        
        decimal:
        l.s $f5,decimalvalue                     # load constant 0.1 to f5, used to calculate digit placement after decimal point
        l.s $f3,decimalvalue                     # used only to hold in constant 0.1
        
        decimalloop:
        lb $v0,($s0)                             # load the next byte
        addi $s0,$s0,1                           # increment address
        
        beq $v0,'\0',floatdone1                  # end of record is reached
        beq $v0,' ',decimalloop                  # if space is found at the end of line, ignore it
        
        ## string to integer parsing
        addiu $v0,$v0,-48                        # convert the string to integer
        mtc1 $v0,$f2                             # move the intger value to a floating point register
        cvt.s.w $f2,$f2                          # convert the integer in f2 from word to a single pricision float
        mul.s $f2,$f2,$f5                        # decimal_digit= integer*(0.1)^n , n being the number of iterations of decimalloop
        mul.s $f5,$f5,$f3                        # f5=f5*0.1 , increases the decimal point
        add.s $f0,$f0,$f2                        # total_decimal = new_decimal + previous,  e.g 0.91 = 0.9 +0.01  :0.01 being the newly found digit
        j decimalloop
        
        floatdone1:
        mtc1 $t8,$f2                             # move the total integer value found before into a float register
        cvt.s.w $f2,$f2                          # convert all the integer value calculated before into a float
        add.s $f0,$f0,$f2                        # add the two numbers together, e.g 112.45 = 112.00 + 0.45
        
        jr $ra               #return
        
        
                                     ##### a function that prints the content of the index list
print_index_list:
         # function that prints the content of the index list 
         # it returns the number of indices found in index list in $v0(return value)
         # note thst this function uses $t9,$t8,$s6,$a3
         move $a3,$ra       # to preserve the return address
         
         addi $t9,$zero,0   # the number for each test
         addi $t8,$zero,0   # index value
         addi $s6,$zero,0   # offset for index list
         
         print_indext_list_loop:
         lw $t8,Index_list($s6)    # load each index 
         beq $t8,-1,done_listing   # check if the end of list is reached
         addi $t9,$t9,1            # increment number before each test
         addi $s6,$s6,4            # increment offset
         mul $t8,$t8,4             # find the index for all arrays
         
         jal newLine
         
          move $a0,$t9 # print the number before each test
          li $v0,1
          syscall
          
          
          li $a0,'-'   # print dash character
          li $v0,11
          syscall
          
          jal space   # print space
        
          lw $a0,Patient_ID($t8) # load the integer
          li $v0,1 # print integer
          syscall
        
          # print space
          jal space 
        
          ### print test name
          lw $a0,Test_Name($t8) # load test mane
          li $v0,4 # print string
          syscall
        
          # print space
          jal space 
        
          ### print date
          lw $a0,Date($t8) # load date
          li $v0,4 # print string
          syscall
        
          # print space
          jal space 
        
          ### print result
          lw $a0,Result($t8) # load the address of float
          li $v0,4 # print string result
          syscall
         
          j print_indext_list_loop
         
         done_listing:
         move $ra,$a3
         jr $ra
        


                                    ### write data into file
write_to_file:
        
        #Open file
	li $v0 , 13          # Open file syscall code = 13
	la $a0 , fileName    # get the file name
	li $a1 ,1            # file flag = write (1)
	syscall
	move $s0 , $v0      # save the file descriptor. $s0 = file
	
	#print an error message if file didn't open
	bge $v0, 0, continue1
	li $v0, 4
        la $a0, fileError
        syscall
        j exit
        
        continue1:
        lw $t0,current_size             # the current size of all arrays
        addi $t1,$zero,0                # offset for each array
        addi $t2,$zero,0                # loop counter
        la $a0,fileString              # load the address of the string to be writtent on file
        addi $a3,$zero,0               # $a3 is very special, it is used to count hte number of characters that will be written on file
        
        join_string_loop:
        beq $t2,$t0,write_string        # break loop if all tests are assembeled
        
        
        #### arrange_ID
        lw $t3,Patient_ID($t1)      # load value
        addi $a0,$a0,6             # go to the address of last byte to store the characters of id
        li $t4, 10                  # $t4 = divisor = 10
        

        L2: divu $t3, $t4 # LO = value/10, HI = value%10

        mflo $t3              # $t3 = value/10
        mfhi $t5              # $t5 = value%10
        addiu $t5, $t5, 48    # convert digit into ASCII
        sb $t5,($a0)          # store character in memory
        addi $a3,$a3,1        # increment the total number of characters written
        addiu $a0, $a0, -1    # point to previous byte
        bnez $t3, L2          # loop if value is not 0
        
        addi $a0,$a0,8        # go back to the address of the byte right ater the id characters
        li $t3,':'            # put : after the end of each id
        sb $t3,($a0)          # store : in memory
        addi $a3,$a3,1        # increment the total number of characters written
        addi $a0,$a0,1        # go to next address
        li $t3,' '            # put space after the end of each id
        sb $t3,($a0)          # store space in memory
        addi $a3,$a3,1        # increment the total number of characters written
        addi $a0,$a0,1        # go to next address
        
        #### arrange name
        lw $a1,Test_Name($t1)            # load the address of name to be written
        addi $t3,$zero,0                 #reset 
        arrange_name_loop:
        lb $t3,($a1)                     # load the character
        addi $a1,$a1,1                   # go to next address of test name
        beq $t3,'\0', arrange_name_done  # end of name string is reached
        sb $t3,($a0)                     # store the byte in string
        addi $a3,$a3,1        # increment the total number of characters written
        addi $a0,$a0,1                   # go to next address
        j arrange_name_loop
        
        arrange_name_done:
        li $t3,','            # put comma after the end of each name
        sb $t3,($a0)          # store : in memory
        addi $a3,$a3,1        # increment the total number of characters written
        addi $a0,$a0,1        # go to next address
        li $t3,' '            # put space after the end of each name
        sb $t3,($a0)          # store space in memory
        addi $a3,$a3,1        # increment the total number of characters written
        addi $a0,$a0,1        # go to next address
        
        
        ### arrange date
        lw $a1,Date($t1)                 # load the address of date to be written
        addi $t3,$zero,0                 #reset 
        arrange_date_loop:
        lb $t3,($a1)                     # load the character
        addi $a1,$a1,1                   # go to next address of test date
        beq $t3,'\0', arrange_date_done  # end of date string is reached
        sb $t3,($a0)                     # store the byte in string
        addi $a3,$a3,1        # increment the total number of characters written
        addi $a0,$a0,1                   # go to next address
        j arrange_date_loop
        
        arrange_date_done:
        li $t3,','            # put comma after the end of each name
        sb $t3,($a0)          # store , in memory
        addi $a3,$a3,1        # increment the total number of characters written
        addi $a0,$a0,1        # go to next address
        li $t3,' '            # put space after the end of each name
        sb $t3,($a0)          # store space in memory
        addi $a3,$a3,1        # increment the total number of characters written
        addi $a0,$a0,1        # go to next address
        
        #### arrange result
        lw $a1,Result($t1)               # load the address of result to be written
        addi $t3,$zero,0                 #reset 
        arrange_result_loop:
        lb $t3,($a1)                     # load the character
        addi $a1,$a1,1                   # go to next address of test result
        beq $t3,'\0', arrange_result_done  # end of result string is reached
        sb $t3,($a0)                     # store the byte in string
        addi $a3,$a3,1        # increment the total number of characters written
        addi $a0,$a0,1                   # go to next address
        j arrange_result_loop
        
        arrange_result_done:
        sub $t4,$t0,$t2         # current size- current iteration
        beq $t4,1,skip_newLine # this is the last record, skip putting a new line at the end 
        li $t3,'\n'            # put new line after the end of each name
        sb $t3,($a0)          # store : in memory
        addi $a3,$a3,1        # increment the total number of characters written
        addi $a0,$a0,1        # go to next address
        skip_newLine:
       
        ### done arranging one entire record 
        addi $t1,$t1,4  # increment offset
        addi $t2,$t2,1  #increment loop counter
        j join_string_loop
        
        
        write_string:
        move $a0,$s0   # file discriptor
        la $a1,fileString
        move $a2,$a3  # move the total number of characters calculated during loop to reg $a2
        li $v0,15
        syscall
        
        li $v0,16      # close file
        syscall
        
        jr $ra
        
                                    ### a function to remove new line from the end of a given string if it exist ###
remove_newLine:
        # address of string is put in $s0
        # registers used : $t9
        addi $t9,$zero,0  # reset
        L10:
        lb $t9,($s0)      # load next byte
        beq $t9,'\n',newLine_found
        beq $t9,'\0',newLine_notfound
        addi $s0,$s0,1
        j L10
        
        newLine_found:
        li $t9,'\0'        # get new null character
        sb $t9,($s0)       # store null instead on new line
        newLine_notfound:
        jr $ra
        
  #########   split date function ######
    
split_date:
    				# Initialize variables
    li $s0, 0   			# Year (integer)
    li $s1, 0   			# Month (integer)
    li $s3, 0   			# Counter  
    li $t8 ,0        
    addi $s7 , $zero , 0
    li $s7 ,10
    
    yearloop:
    lb $t8,($a0)           		# load the next byte
    beq $t8,'-',next_char     	# Found the dash , finished reading year
        
    addi $a0,$a0,1         		# increment the address to equal the address of the next byte
        
        				# string to integer parsing
    addiu $t8,$t8,-48      		#convert the string to integer
    mul $s3,$s3,$s7        		#sum=sum*10
    add $s3,$s3,$t8        		#sum=sum+digit
    move $s0 , $s3     
    j yearloop
     
    next_char:
    addi $s3, $s3, 1   			# Increment counter
    addi $a0, $a0, 1   			# Move to next character in string
    j parse_month   			# If dash is found, start parsing month
        
    
    parse_month:   
    li $s3, 0   			# Counter  
    li $t8 ,0 
    
    month_loop:                      
    lb $t8,($a0)           		# load the next byte
    
    beq $t8 ,'\0', end_parse
    addi $a0, $a0, 1
     
    addiu $t8,$t8,-48      		#convert the string to integer
    mul $s3,$s3,$s7       		#sum=sum*10
    add $s3,$s3,$t8        		#sum=sum+digit                                                                                    
    move $s1 , $s3 
    j month_loop
      
                                                                                                                                                      
    end_parse:
    jr $ra   				# Return to caller

        

#########################################################################################################################################
#                                                              SPLIT FILE CONTENTS                                                      #
#########################################################################################################################################

        
                                    
splitData:

        lw $t0,current_size  # counter for current size
        addi $t1,$zero,0  # register to calculate offset
        addi $s0,$zero,0  # address of the next byte to be read from fileWords
        la $s0,fileWords  # load the address of first byte
        addi $s7,$s7,1     #######testing
        
       
       ### BIG LOOP START! ###  
       newrecord:
       
       ### criteria for breaking the loop ###
       ble $s7,0,main      # if total char left to read is zero, then all chars have been read
        
        ## offset calculation
        addi $t1,$zero,0 # reset register
        lw $t1,ID_size #load the size od each ID
        mul $t1,$t1,$t0 # offset for patient id array = current_overall_size + the size for_each_ID 
        
        addi $t6,$zero,10 # to keep multiplying sum by 10 each iteration of IDloop
        addi $t7,$zero,0  # keep track of sum of ID
 
        IDloop:
        lb $t2,($s0)           # load the next byte
        addi $s0,$s0,1         # increment the address to equal the address of the next byte
        subi $s7,$s7,1         # subtract this char from the total number of charcters in file
        
        ## loop break criteria
        beq $t2,' ',IDloop     # ignore space character if encountered
        beq $t2,':',IDdone     # ID finished reading
        
        ## string to integer parsing
        addiu $t2,$t2,-48      #convert the string to integer
        mul $t7,$t7,$t6        #sum=sum*10
        add $t7,$t7,$t2        #sum=sum+digit
        
        j IDloop
        
        #### Assume that ID is fixed at 7 digits (exception handeing later!)
        
        IDdone:
        sw $t7,Patient_ID($t1) # store integer into address of label patient id
        
        trim1:
        lb $t2,($s0)           # load the next byte
        bne $t2,' ',saveAddress1     # if space is not found
        addi $s0,$s0,1         # if space is found then trim it
        subi $s7,$s7,1         # subtract this char from the total number of charcters in file
        j trim1
        
        saveAddress1:
        move $t7,$s0     # save the address of the first byte
        
        nameloop:
        lb $t2,($s0)           # load the next byte
        
        ## loop break criteria
        beq $t2,',',namedone     # name finished scanning(note that if comma is found then $s0 is not incremented yet!)
        
        addi $s0,$s0,1         # increment the address to equal the address of the next byte
        subi $s7,$s7,1         # subtract this char from the total number of charcters in file
        
        j nameloop
        
        namedone:
        sb $zero,($s0) # instead for comma, store null to limit the end of the string!
        sw $t7,Test_Name($t1) # store the address of the first byte of string into Test_Name array
        addi $s0,$s0,1         # increment the address to equal the address of the next byte
        subi $s7,$s7,1         # subtract this char from the total number of charcters in file
        
        
        trim2:
        lb $t2,($s0)           # load the next byte
        bne $t2,' ',saveAddress2     # if space is not found
        addi $s0,$s0,1         # if space is found then trim it
        subi $s7,$s7,1         # subtract this char from the total number of charcters in file
        j trim2
        
        saveAddress2:
        move $t7,$s0     # save the address of the first byte
        
        
        dateloop:
        lb $t2,($s0)              # load the next byte
        
        ## loop break criteria
        beq $t2,',',datedone     # name finished scanning(note that if comma is found then $s0 is not incremented yet!)
        
        addi $s0,$s0,1         # increment the address to equal the address of the next byte
        subi $s7,$s7,1         # subtract this char from the total number of charcters in file
        j dateloop
        
        
        datedone:
        sb $zero,($s0) # instead for comma, store null to limit the end of the string!
        sw $t7,Date($t1) # store the address of the first byte of string into Date array
        addi $s0,$s0,1         # increment the address to equal the address of the next byte
        subi $s7,$s7,1         # subtract this char from the total number of charcters in file
        
        
        
         trim4:
        lb $t2,($s0)           # load the next byte
        bne $t2,' ',saveAddress4     # if space is not found
        addi $s0,$s0,1         # if space is found then trim it
        subi $s7,$s7,1         # subtract this char from the total number of charcters in file
        j trim4
        
        saveAddress4:
        move $t7,$s0     # save the address of the first byte
        
        
        floatloop:
        lb $t2,($s0)              # load the next byte
        
        ## loop break criteria
        beq $t2,'\n',floatdone  # end of record is reached(no decimal value is found, still number is concedered as float)
        beq $s7,0,floatdone    # if all char hve been read, save the float then branch to main
        
        addi $s0,$s0,1         # increment the address to equal the address of the next byte
        subi $s7,$s7,1         # subtract this char from the total number of charcters in file
        j floatloop
        
        
        floatdone:
        sb $zero,($s0) # instead for comma, store null to limit the end of the string!
        sw $t7,Result($t1) # store the address of the first byte of string into Date array
        addi $s0,$s0,1         # increment the address to equal the address of the next byte
        subi $s7,$s7,1         # subtract this char from the total number of charcters in file
        
        
        
        
        ### increment the global current size of all parallel arrays  
        addi $t0, $t0, 1        #increment current size
        sw   $t0, current_size  # store the new size 
        beq $s7,0,main      # if total char left to read is zero, then all chars have been read
        subi $v0,$s7,1      # in case of new-line character found at the end of the file
        beq $v0,0,main      # if total char left to read is zero, then all chars have been read
        
        j newrecord
        
                        
        j main
       
       
       
        
#########################################################################################################################################
#                                                                 DELETE A TEST                                                         #
#########################################################################################################################################
          
        
                                     
delete_test:

       lw $t0,current_size # the current size of all medical records

       jal search_id
       
       # Prompt
       li $v0, 4
       la $a0, prompt
       syscall
       
       jal print_index_list     # print all tests of that id, return value is the number of tests(indices) found in index list in $v0
         move $a2,$v0           # preserve the value of v0,(a2 has the total number of test for that spesific patient id)
         jal newLine
         
       # Read user input(in string form!)
         li $v0, 8
         la $a0,choice             # address of buffer choice
         li $a1,2                  # to limit the number of characters read
         syscall
         jal check_integer_choice  # check if the input choice is an integer
         
         beq $v1,$zero,invalid_input_format
         ble $v1,$a2,delete        # if the chosen test number is valid(less than or equal to the number of total tests found in index list), then delete it
         j invalid_input_format    # validation of user input
         
       delete:  # test is found! then delete it
       subi $v1,$v1,1         # subtract v1 by 1, to get index of intentded test in index_list
       mul $v1,$v1,4          # get offset for index list
       lw $v1,Index_list($v1) # get the index for all parallel arrays
       addi $t1,$zero,0       # offset
       move $t2,$v1           # index of deteted test
       
       
       #### get the addresses for all arrays ####
        ## patient ID array
        lw $t1,ID_size
        mul $t1,$t1,$t2
        la $t3,Patient_ID($t1)
        
        ## name array
        li $t1,4
        mul $t1,$t1,$t2
        la $t4,Test_Name($t1)
        
        ## date array
        li $t1,4
        mul $t1,$t1,$t2
        la $t5,Date($t1)                             #### here t3-t6 hold address value for the index of $v0(deleted record) across all arrays ####
        
        ## result array
        lw $t1,result_size
        mul $t1,$t1,$t2
        la $t6,Result($t1)
        
        lw $t0,current_size # the current size of all medical records
        
       #### start shifting ####
          shiftloop:
          addi $t2,$t2,1 #increment counter
          bge $t2,$t0,decrement # break the loop if current_index >= current_size
          
          #### for patient_ID array
          lw $a0,4($t3) # load next value
          sw $a0,($t3)  # store on current value
          addi $t3,$t3,4 # increment address
          
          #### for Test_Name array
          lw $a0,4($t4) # load next value
          sw $a0,($t4)  # store on current value
          addi $t4,$t4,4 # increment address
          #### for Date array
          lw $a0,4($t5) # load next value
          sw $a0,($t5)  # store on current value
          addi $t5,$t5,4 # increment address
          #### for Test_Name array
          lw $a0,4($t6) # load next value
          sw $a0,($t6)  # store on current value
          addi $t6,$t6,4 # increment address
          
          j shiftloop
          
        
       #### fix total size ####     
       decrement:
       sub $t0,$t0,1       # decrement the total size
       sw $t0,current_size # store the new value
       
       li $v0, 4 #print string prompt
       la $a0,delete_prompt
       syscall
       jal write_to_file
       j main
       
       not_found:
       li $v0, 4 #print string prompt
       la $a0,delete_error_prompt
       syscall
       j main
       
       
   
#########################################################################################################################################
#                                                          SEARCH FOR A PATIENT BY ID                                                   #
#########################################################################################################################################
   
                                     #### Search ID Function ####
       
search_id: 

 
  lw $t0,current_size
  
                
       search_ID:
       li $v0, 4 #print string prompt
       la $a0,addtest_ID_prompt
       syscall
       
       li $v0,8
       la $a0,ID_str
       addi $a1,$zero,8                                      # read integer
       syscall
   
       move $s0,$a0                                 # checking the ID format
       move $a3,$ra                                 # preserve return address
       jal check_ID_format
       beq $v1,-1,not_valid2
      j valid2
   
      not_valid2:
      li $v0, 4                                     # print string prompt
      la $a0,ID_invalid_prompt
      syscall
      j search_ID
   
      valid2:
       move $ra,$a3    # get back the return address
       
       move $s0,$v1 # get the ID
       
  
  	la $a0 ,Patient_ID
  	
  	addi $t1, $zero, 0     # loop index
  	addi $t5 ,$zero, 0     # indes_list counter (to keep track of current size)
  	addi $t4, $zero, 0     # offset for index_list array
  	
  	
  	# Loop to compare id
searchloop:
  	beq $t1, $t0, search_end
  	mul $t2, $t1, 4     # Calculate offset (index * size of each element)
 	lw $t3, Patient_ID($t2)   # Load the patient ID from the array
  	
  	
  	beq $s0, $t3, id_found
  	
  	
 	addi $t1, $t1, 1          # Increment loop index
 	j searchloop                    # Repeat loop

    id_found:
    # Set $v0 to the index where the match was found
    mul $t4,$t5,4            # calculate the offset for the index_list
    sw $t1 , Index_list($t4)   # store the index in new offset
    addi $t5,$t5,1             # incremnt $t3(the dedicated counter for index_list)
    addi $t2, $t2, 1           # Increment counter for matching indices
    addi $a0, $a0, 4           # Move to the next element in the array
     
   
    
      addi $t1, $t1, 1           # Increment loop index
      j searchloop 
    
    
   search_end:
    ### store -1 at the end of the list to identify the end of the index_list
    mul $t4,$t5,4            # calculate the offset for the index_list
    li $t1,-1                  # load -1
    sw $t1 , Index_list($t4)   # store the index in new offset
    lw $t0,Index_list
    beq $t0,-1,ID_notfound
    jr $ra
    
    ID_notfound:  # if patient ID not found
    li $v0,4  # print string
    la $a0, search_id_error_prompt
    syscall
    
    j main  # terminate search procedure
    
  
  
 
    
       
                                     #### search for a specific test by patient ID ####
Search:  

        jal search_id   # search for ID indices
        
        li $v0, 4 #print string prompt
        la $a0,search_menu
        syscall
        
        
        # Read user input(in string form! )
        li $v0, 8
        la $a0,choice             # address of buffer choice
        li $a1,2                  # to limit the number of characters read
        syscall
        jal check_integer_choice 
        move $v0,$v1              # move the return value to $v0
        
        beq $v0,1,display_all_patient_tests
        beq $v0,2,display_upnormal_patient_tests
        beq $v0,3,display_patient_tests_given_period
        
        jal newLine
        j invalid_input_format
        
        j main
        
        
display_all_patient_tests:

	li $t0,0   # offset of the index list
		
    loop1:
    lw $t1, Index_list($t0)       # Load the current index
    beq $t1,-1, main         # If index is -1 (end of array), exit loop
    
    jal newLine
    
    li $v0,4  # print string
    la $a0, Display_Test_Name
    syscall
       
    mul $t2, $t1, 4               # offset for test_name array
    lw $a0, Test_Name($t2)        # load the test name
     
    li $v0, 4
    syscall
    
    jal newLine
    
    li $v0,4  # print string
    la $a0, Display_Test_Result
    syscall
    
    lw $a0, Result($t2)   
    li $v0, 4         #Print string result
    syscall

    jal newLine


    li $v0,4  # print string
    la $a0, Display_Test_Date
    syscall
    
    lw , $a0 , Date($t2)
    li , $v0 , 4
    syscall
    
    jal newLine
    jal newLine

    addi $t0, $t0, 4
    j loop1
    

 
display_upnormal_patient_tests:
###### Asuume that all tests in medical tests are valid!!!!! ###

       addi $t0,$zero,0  # a register to keep track of index gotten from index_list
       addi $t1,$zero,0  # offset for index_list
       
       
       patient_upnormaltests_loop:
       lw $t0,Index_list($t1) # load each index
       beq $t0,-1,finished    # all tests are done listing
       mul $t0,$t0,4          # offset for all other arrays
       
       Hgb:
       lw $s0,Test_Name($t0)   # get the address of test name in array
       la $s1,Hgb_name         # get the address of name of Hgb test
       jal compare                # begin compareson
       beq $v0,1,checkHgbRange   # check the range if the test is Hgb
       
       BGT:
       lw $s0,Test_Name($t0)   # get the address of test name in array
       la $s1,BGT_name         # get the address of name of BGT test
       jal compare                # begin compareson
       beq $v0,1,checkBGTRange   # check the range if the test is BGT
       
       LDL:
       lw $s0,Test_Name($t0)   # get the address of test name in array
       la $s1,LDL_name         # get the address of name of LDL test
       jal compare                 # begin compareson
       beq $v0,1,checkLDLRange   # check the range if the test is LDL
       
       BPD:
       lw $s0,Test_Name($t0)   # get the address of test name in array
       la $s1,BPD_name         # get the address of name of BPD test
       jal compare                 # begin compareson
       beq $v0,1,checkBPDRange   # check the range if the test is BPD
       
       BPS:
       lw $s0,Test_Name($t0)   # get the address of test name in array
       la $s1,BPS_name         # get the address of name of BPS test
       jal compare                 # begin compareson
       beq $v0,1,checkBPSRange   # check the range if the test is BPS
       
       
       checkHgbRange:
       lw $s0,Result($t0)    #load the result
       jal convert_to_float
       lwc1 $f1,Hgb_lower      # lower range
       lwc1 $f2,Hgb_upper      # upper range
       
       c.lt.s $f0,$f1          #if result<lower then unnormal
       bc1t print_upnormal_test
       c.le.s $f0,$f2          #if lower<= result <=upper
       bc1t normal
       j print_upnormal_test   #if upper<result (the left out posibility)
       
       
       checkBGTRange:
       lw $s0,Result($t0)    #load the result
       jal convert_to_float
       lwc1 $f1,BGT_lower      # lower range
       lwc1 $f2,BGT_upper      # upper range
       
       c.lt.s $f0,$f1          #if result<lower then unnormal
       bc1t print_upnormal_test
       c.le.s $f0,$f2          #if lower<= result <=upper
       bc1t normal
       j print_upnormal_test   #if upper<result (the left out posibility)
       
       
       checkLDLRange:
       lw $s0,Result($t0)    #load the result
       jal convert_to_float
       lwc1 $f2,LDL_upper      # upper range
       
       c.lt.s $f0,$f2          #if  result <upper
       bc1t normal
       j print_upnormal_test   #if upper<=result (the left out posibility)
       
       
       checkBPDRange:
       lw $s0,Result($t0)    #load the result
       jal convert_to_float
       lwc1 $f1,BPD_upper      # upper range for type 1 BPT test
       
       c.lt.s $f0,$f1          #if result<upper then normal
       bc1t normal
       j print_upnormal_test   #if upper<=result (the left out posibility)
       
       
       checkBPSRange:
       lw $s0,Result($t0)    #load the result
       jal convert_to_float
       lwc1 $f1,BPS_upper      # upper range for type 2 BPT test
       
       c.lt.s $f0,$f1          #if result<upper then normal
       bc1t normal
       j print_upnormal_test   #if upper<=result (the left out posibility)
       
       
       
       print_upnormal_test:
       ### print patient ID
        move $t2,$t0 # find offset for array
        jal newLine
        
        lw $a0,Patient_ID($t2) # load the integer
        li $v0,1 # print integer
        syscall
        
        # print space
        jal space 
        
        ### print test name
        lw $a0,Test_Name($t2) # load test mane
        li $v0,4 # print string
        syscall
        
        # print space
        jal space 
        
        ### print date
        lw $a0,Date($t2) # load date
        li $v0,4 # print string
        syscall
        
        # print space
        jal space 
        
        ### print result
        lw $a0,Result($t2) # load the address of float
        li $v0,4 # print single precision float
        syscall
        
        
     
       normal:
       addi $t1,$t1,4               # increment offset for the index_list array
       j patient_upnormaltests_loop # check other tests
       
       
   
       finished:  # all upnormal tests have been listed
       j main

####################### Search specific period ################        
                   
   display_patient_tests_given_period: 
  
  addi $t3 ,$zero ,0			#t3 --> year (array)
  addi $t4 ,$zero ,0			#t4 --> year (to)     
  addi $t5 ,$zero ,0			#t5 --> month (to)
  addi $t6 ,$zero ,0			#t6 --> month (from)
  addi $t7 ,$zero ,0			#t7 --> year (from)
  addi $t9 ,$zero ,0			#t9 --> month array
  addi $t0 ,$zero ,0 			#t0 --> counter
   
   ask_again:
    li $v0, 4     			#Ask user to enter date 
    la $a0, From_date
    syscall
    
       
    li $v0,8    			#read string
    la $a0,date($t0) 
    li $a1,8     			#max characters to read
    syscall
   
   
    addi $s0 ,$zero ,0
    addi $s1 ,$zero ,0
  
  
    jal check_date_format
    beq $v1 , -1 , ask_again
    
    
        					#call split function
    jal split_date
    move $t7 , $s0  			#contains year
    move $t6 , $s1 			# contain month  
    
    jal newLine
    
    ask_again2:
    li $v0, 4 				#Ask user to enter date 
    la $a0, To_date
    syscall 
    
        
    addi $t0, $t0, 4 
    li $v0,8    			#read string
    la $a0,date($t0) 
   
    li $a1,8     			#max characters to read
    syscall
  
   addi $s0 ,$zero ,0
   addi $s1 ,$zero ,0
   
   jal check_date_format
   beq $v1 , -1 , ask_again2
  
 
 					 
   jal split_date			###call split function
  
    move $t4 , $s0  			#contains year
    move $t5 , $s1 			# contain month 
  
  
    bgt $t7 , $t4 , invalid_range
  
  
    addi $t0 ,$zero ,0 
    addi $t1 ,$zero, 0     
    addi $t2 ,$zero, 0 
    addi $s5 ,$zero ,0  
   
              
    loop_date:				#Search the date array 
    addi $t3 ,$zero ,0
    addi $t9 ,$zero ,0
    addi $s0 ,$zero ,0			#s0 used for year value
    addi $s1 ,$zero ,0			#s1 used for month value
    
    
    lw $t1, Index_list($t0)
    beq $t1,-1, endloop_date  
    
    mul $t2, $t1, 4                      # offset for Date array
    lw $a0, Date($t2)                    # load the test name
    
    jal split_date
    move $t3 , $s0  			 #contains year
    move $t9 , $s1 			 #contain month  
    
        				 #checking the following range : t7 < t3 < t4
    bgt $t3 , $t7 , next_range           #checking if the test date is greater than the entered from date 
    beq $t3 , $t7 , next_range2     	 #If years equal check month			
    
    
    addi $t0, $t0, 4  
    j loop_date
    
    next_range:
     blt $t3 , $t4 , date_found         #checking if the test date is less than the entered to date
     addi $t0, $t0, 4
     j loop_date
          
    date_found:
    jal newLine
    li $v0,4  				# print string
    la $a0, Test
    syscall  
                   
    lw $a0, Test_Name($t2)        	# load the test name
    li $v0, 4
    syscall
    
    jal space
    
    lw $a0, Result($t2)   		#load result
    li $v0, 4         			#Print string result
    syscall

    jal space
    
    lw $a0, Date($t2)   		#load result
    li $v0, 4         			#Print string result
    syscall
    
    jal space
   
    addi $t0, $t0, 4  			# Increment loop 
    li $s5 ,1
    j loop_date
                        
  
   next_range2:     			# checking the years range 
   beq $t3 , $t4 , check_month1 	#checking month range
   j loop_date
  
    
   check_month1:                        #checking first range for month
   bge $t9 , $t6 , check_month2
   j loop_date
 
   check_month2: 			#checking second range for month
    ble $t9 , $t5 , date_found
    addi $t0, $t0, 4
    j loop_date
  
   period_not_found:
   jal newLine
   
   li $v0,4  # print string
   la $a0, search_period_error
   syscall
    
   jal newLine
   j main                             
     
                                                            
   invalid_range:
   li $v0,4  # print string
   la $a0, error_range
   syscall
   j ask_again                                                                                                                                                                   
                                                                                                                      
   endloop_date:              
   jal newLine
   beq $s5 , 0 , period_not_found
   j main                                   


    
        
#########################################################################################################################################
#                                                       DISPLAY ABNORMAL TESTS OF A TEST                                                #
#########################################################################################################################################
    

display_upnormal_tests:
       
       addi $t1,$zero,0    # reset register ,used for offset
       addi $t6,$zero,0    # loop counter
       lw $t0,current_size # current size for all arrays
       
       label1:
       li $v0, 4 #print string prompt
       la $a0,addtest_name_prompt
       syscall
       
       li $v0,8 #read string
       la $a0,string #input buffer  changed every time a string is read from user
       li $a1,4 #max chracters to read
       syscall
       
       upnormaltests_loop:
       #### note: string must be loaded on s0 each time, because in compare loop, s0 might change value
       la $s0,string           # load the address of string enetered by user
       la $s1,Hgb_name         # get the address of name of Hgb test
       jal compare             # compare strings
       beq $v0,1,Hgb1          # go to Hgb loop
       
       la $s0,string           # load the address of string enetered by user
       la $s1,BGT_name         # get the address of name of BGT test
       jal compare             # compare strings
       beq $v0,1,BGT1          # go to BGT loop
       
       la $s0,string           # load the address of string enetered by user
       la $s1,LDL_name         # get the address of name of LDL test
       jal compare             # compare strings
       beq $v0,1,LDL1          # go to LDLloop
       
       la $s0,string           # load the address of string enetered by user
       la $s1,BPD_name         # get the address of name of BPD test
       jal compare             # compare strings
       beq $v0,1,BPD1          # go to BPD loop
       
       la $s0,string           # load the address of string enetered by user
       la $s1,BPS_name         # get the address of name of BPS test
       jal compare             # compare strings
       beq $v0,1,BPS1          # go to BPS loop
       
       ### handeling unrecognizable test names entered by users
       testname_unrecognizable:
       li $v0, 4 #print string prompt
       la $a0,testname_error_prompt
       syscall
       j main
       
       
       ##### check the string and determine the test
       Hgb1:
       beq $t6,$t0,finished1   # break the loop if all tests have been evaluated
       lw $s0,Test_Name($t1)   # get the address of test name in array
       la $s1,Hgb_name         # get the address of name of Hgb test
       jal compare                # begin compareson
       beq $v0,1,checkHgbRange1   # check the range if the test is Hgb
       normal1:
       addi $t1,$t1,4               # increment offset for the index_list array
       addi $t6,$t6,1               # increment loop counter
       j Hgb1         # check other tests
       
       
       BGT1:
       beq $t6,$t0,finished1   # break the loop if all tests have been evaluated
       lw $s0,Test_Name($t1)   # get the address of test name in array
       la $s1,BGT_name         # get the address of name of BGT test
       jal compare                # begin compareson
       beq $v0,1,checkBGTRange1   # check the range if the test is BGT
       normal2:
       addi $t1,$t1,4               # increment offset for the index_list array
       addi $t6,$t6,1               # increment loop counter
       j BGT1         # check other tests
       
       
       LDL1:
       beq $t6,$t0,finished1   # break the loop if all tests have been evaluated
       lw $s0,Test_Name($t1)   # get the address of test name in array
       la $s1,LDL_name         # get the address of name of LDL test
       jal compare                 # begin compareson
       beq $v0,1,checkLDLRange1   # check the range if the test is LDL
       normal3:
       addi $t1,$t1,4               # increment offset for the index_list array
       addi $t6,$t6,1               # increment loop counter
       j LDL1         # check other tests
       
       
       BPD1:
       beq $t6,$t0,finished1   # break the loop if all tests have been evaluated
       lw $s0,Test_Name($t1)   # get the address of test name in array
       la $s1,BPD_name         # get the address of name of BPD test
       jal compare                 # begin compareson
       beq $v0,1,checkBPDRange1   # check the range if the test is BPD
       normal4:
       addi $t1,$t1,4               # increment offset for the index_list array
       addi $t6,$t6,1               # increment loop counter
       j BPD1         # check other tests
      
      
       BPS1:
       beq $t6,$t0,finished1   # break the loop if all tests have been evaluated
       lw $s0,Test_Name($t1)   # get the address of test name in array
       la $s1,BPS_name         # get the address of name of BPS test
       jal compare                 # begin compareson
       beq $v0,1,checkBPSRange1   # check the range if the test is BPS
       normal5:
       addi $t1,$t1,4               # increment offset for the index_list array
       addi $t6,$t6,1               # increment loop counter
       j BPS1         # check other tests
   
       
       
       checkHgbRange1:
       lw $s0,Result($t1)    #load the result
       jal convert_to_float
       lwc1 $f1,Hgb_lower      # lower range
       lwc1 $f2,Hgb_upper      # upper range
       
       c.lt.s $f0,$f1          #if result<lower then unnormal
       bc1t print_upnormal_test1
       c.le.s $f0,$f2          #if lower<= result <=upper
       bc1t normal1
       j print_upnormal_test1   #if upper<result (the left out posibility)
       
       
       checkBGTRange1:
       lw $s0,Result($t1)    #load the result
       jal convert_to_float
       lwc1 $f1,BGT_lower      # lower range
       lwc1 $f2,BGT_upper      # upper range
       
       c.lt.s $f0,$f1          #if result<lower then unnormal
       bc1t print_upnormal_test1
       c.le.s $f0,$f2          #if lower<= result <=upper
       bc1t normal2
       j print_upnormal_test1   #if upper<result (the left out posibility)
       
       
       checkLDLRange1:
       lw $s0,Result($t1)    #load the result
       jal convert_to_float
       lwc1 $f2,LDL_upper      # upper range
       
       c.lt.s $f0,$f2          #if  result <upper
       bc1t normal3
       j print_upnormal_test1   #if upper<=result (the left out posibility)
       
       
       checkBPDRange1:
       lw $s0,Result($t1)    #load the result
       jal convert_to_float
       lwc1 $f1,BPD_upper      # upper range
       
       c.lt.s $f0,$f1          #if result<upper then normal
       bc1t normal4
       j print_upnormal_test1   #if upper<=result (the left out posibility)
       
       
       checkBPSRange1:
       lw $s0,Result($t1)    #load the result
       jal convert_to_float
       lwc1 $f1,BPS_upper      # upper range
       
       c.lt.s $f0,$f1          #if result<upper then normal
       bc1t normal5
       j print_upnormal_test1   #if upper<=result (the left out posibility)
       
       
       print_upnormal_test1:
       ### print patient ID
        move $t2,$t1 # find offset for array
        jal newLine
        
        lw $a0,Patient_ID($t2) # load the integer
        li $v0,1 # print integer
        syscall
        
        # print space
        jal space 
        
        ### print test name
        lw $a0,Test_Name($t2) # load test mane
        li $v0,4 # print string
        syscall
        
        # print space
        jal space 
        
        ### print date
        lw $a0,Date($t2) # load date
        li $v0,4 # print string
        syscall
        
        # print space
        jal space 
        
        ### print result
        lw $a0,Result($t2) # load the float
        li $v0,4 # print single precision float
        syscall
        
        
       addi $t1,$t1,4               # increment offset for the index_list array
       addi $t6,$t6,1                # increment loop counter
      j upnormaltests_loop
  
       finished1:  # all upnormal tests have been listed
         ### print new line
        jal newLine
       j main



#########################################################################################################################################
#                                                           FIND AVERAGE TEST RESULT                                                    #
#########################################################################################################################################


find_average_testresult:
       
       li $v0, 4 #print string prompt
       la $a0,addtest_name_prompt
       syscall
       
       li $v0,8 #read string
       la $a0,string #input buffer  changed every time a string is read from user
       li $a1,4 #max chracters to read
       syscall
       
       #### check valid test name
       move $s0,$a0
       la   $s1,Hgb_name
       jal compare
       beq $v0,1,contin
       
       move $s0,$a0
       la   $s1,BGT_name
       jal compare
       beq $v0,1,contin
       
       move $s0,$a0
       la   $s1,LDL_name
       jal compare
       beq $v0,1,contin
       
       move $s0,$a0
       la   $s1,BPD_name
       jal compare
       beq $v0,1,contin
       
       move $s0,$a0
       la   $s1,BPS_name
       jal compare
       beq $v0,1,contin
       
       j  testname_unrecognizable
       
       contin:
       addi $t1,$zero,0  # for offset
       addi $t6,$zero,0   # loop counter
       mtc1 $zero,$f1     # to calculate sum
       addi $t7,$zero,0   # to calculate count
       lw $t0,current_size  # load the current size
       
       sum_loop:
       beq $t6,$t0,sumfinished
       move $s0,$a0  # but string address on s0
       lw $s1,Test_Name($t1)   # lod each test name and check if it is the sam as the test entered by user
       jal compare 
       beq $v0,1,sum  # if it matches the entered test, then add it's result to the sum
       addi $t1,$t1,4  # increment offset
       addi $t6,$t6,1  # increment the loop iteration
       j sum_loop
       
       sum:
       addi $t7,$t7,1  #increment the count
       lw $s0,Result($t1) # load the address of result
       jal convert_to_float
       add.s $f1,$f1,$f0    # add the result to sum
       addi $t1,$t1,4  # increment offset
       addi $t6,$t6,1  # increment the loop iteration
       j sum_loop
       
       sumfinished:
       mtc1 $t7,$f0 # move the count to f0
       cvt.s.w $f0,$f0 # convert the integer in f0 to a single pricision float
       div.s $f1,$f1,$f0 # divide sum by count
       
       jal newLine
       
       li $v0,4 # print string
       la $a0,average_value_prompt
       syscall
       
       li $v0,4 # print string
       la $a0,Display_Test_Name
       syscall
       
       li $v0,4 # print test name
       la $a0,string
       syscall
       
       jal space
       
       li $v0,4 # print string
       la $a0,Display_average_result
       syscall
       
       li $v0,2 # print float
       mov.s $f12,$f1
       syscall
       
       jal newLine
       j main
       
       


#########################################################################################################################################
#                                                               UPDATE A TEST                                                           #
#########################################################################################################################################
                            
       
 Update_Results:    
  
   jal search_id
   
       # Prompt
       li $v0, 4
       la $a0, prompt
       syscall
       
       jal print_index_list     # print all tests of that id, return value is the number of tests(indices) found in index list in $v0
         move $a2,$v0           # preserve the value of v0,(a2 has the total number of test for that spesific patient id)
         jal newLine
         
       # Read user input(in string form!)
         li $v0, 8
         la $a0,choice             # address of buffer choice
         li $a1,2                  # to limit the number of characters read
         syscall
         jal check_integer_choice  # check if the input choice is an integer
         
         beq $v1,$zero,invalid_input_format
         ble $v1,$a2,Update_start        # if the chosen test number is valid(less than or equal to the number of total tests found in index list), then update it
         j invalid_input_format    # validation of user input                                                                          
   
   Update_start:               
  
    subi $v1,$v1,1  # to get exact index of index_list array
    mul $v1,$v1,4
    lw $t1, Index_list($v1)   #get the indecies from the index array
    
    li $v0,4  # print string
    la $a0, Display_Test_Result
    syscall
    
    mul $t2, $t1, 4
    lw $a0, Result($t2)   
    li $v0, 4         #Print sting result
    syscall

    jal newLine
    
    update_res_label:
    li $v0,4     # print string
    la $a0, update_result
    syscall
    
    lw $t2,result_size     # load the size for each result string
    mul $t2,$t2,$t1        # get the offset 
    
    
    li $v0,8 # read float as string
    la $a0,flt($t2)
    li $a1,20
    syscall
    
    
    move $s0,$a0                                  # pass the address of flt as an argument to function remove_newLine
    jal remove_newLine                            # remove the new line character from the end of string
   
    move $s0,$a0                                  # pass the address of flt as an argument to function cheack_float_format
    jal check_float_format                        # check the format of entered result by user
    bne $v1,-1,valid5
   
    la $a0,result_invalid_prompt                 # print error test result
    li $v0,4
    syscall
    j update_res_label
   
    valid5:
     mul $t2, $t1, 4                            # offset for result array
    sw $a0,Result($t2)
    
  
    jal newLine
    
   
   
    end_loop4: 

    li $v0,4     # print string
    la $a0, update_message
    syscall
    jal write_to_file   	
    j main
   
   
 
    notfound:
   jal newLine
    li $v0,4  # print string 
    la $a0,search_id_error_prompt  #### note change the prompt
    syscall
    
   jal newLine
   j main 
       
          
                         
 
   endloop3:
  j main 


#########################################################################################################################################
#                                                                      EXIT                                                             #
#########################################################################################################################################
              
        
                                     #### exit ####  
exit:
    li      $v0, 10
    syscall
    


