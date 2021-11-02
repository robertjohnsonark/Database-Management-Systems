ACCEPT user_c_id PROMPT "Enter the c_id value please: ";
ACCEPT user_v_id PROMPT "Enter the v_id value please: ";
ACCEPT user_miles_out PROMPT "Enter the miles_out value please: ";
Declare
	var_c_id customers.c_id%type;
	Cursor customer_id is Select c_id from Customers where c_id=&user_c_id;
	var_v_id vehicles.id%type;
	Cursor vehicle_id is Select id from Vehicles where id=&user_v_id;
	var_miles_out rentals.miles_out%type;
	Cursor vehicle_miles_out is Select miles_out from Rentals where v_id=&user_v_id and ret_date IS NULL;
	 no_data_found Exception;
Begin
	Open customer_id;
	Fetch customer_id into var_c_id;
		If customer_id%NOTFOUND THEN
			dbms_output.put_line ('The c_id entered does not exist in the customers table. ');
			Raise no_data_found;
		END If;
	Close customer_id;
	Open vehicle_id;
	Fetch vehicle_id into var_v_id;
		If vehicle_id%NOTFOUND THEN
			dbms_output.put_line ('The v_id entered does not exist in the vehicles table. ');
			Raise no_data_found;
		END If;
	Close vehicle_id;
	Open vehicle_miles_out;
	Fetch vehicle_miles_out into var_miles_out;
		If vehicle_miles_out%FOUND THEN
			dbms_output.put_line ('The vehicle trying to be rented has not been returned yet. ');
			Raise no_data_found;
		END If;
	Close vehicle_miles_out;
	insert into rentals values(&user_c_id,&user_v_id,to_date(sysdate),&user_miles_out,null,null);
	commit;
	dbms_output.put_line ('The record was added successfully. ');
Exception
	When no_data_found then
		Rollback;
End;
/