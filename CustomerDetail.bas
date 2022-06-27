B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Activity
Version=11
@EndOfDesignText@
#Region  Activity Attributes 
	#FullScreen: False
	#IncludeTitle: False
#End Region

Sub Process_Globals
	'These global variables will be declared once when the application starts.
	'These variables can be accessed from all modules.
	Dim SQL1 As SQL
	Dim cursor1 As Cursor
	Dim dtCode As Cursor
	Private rp As RuntimePermissions
	Private shared As String
End Sub

Sub Globals
	'These global variables will be redeclared each time the activity is created.
	'These variables can only be accessed from this module.
	Private kvs As KeyValueStore
	Dim SelectedCustomerID As String
	Dim Action As String	
	Dim CustomerCode As String
	Dim btnBack As Button
	Dim btnSave As Button
	Dim txtCustomerName As EditText
	Dim txtAddress1 As EditText
	Dim txtAddress2 As EditText
	Dim txtAddress3 As EditText
	Dim txtAddress4 As EditText
	Dim txtPhoneNo As EditText
	Dim txtFaxNo As EditText
	Dim txtContactPerson As EditText
	Dim txtMobileNo As EditText
	Dim txtEmail As EditText
	Dim cboCustomerLevel As Spinner
	Private txtCustomerCode As EditText
	Private txtLng As EditText
	Private txtLat As EditText
	Private ScrollView1 As ScrollView
	Private cboLocation As Spinner
	
End Sub

Sub Activity_Create(FirstTime As Boolean)
	'Do not forget to load the layout file created with the visual designer. For example:
	Activity.LoadLayout("lyCustomerDetail")
	shared = rp.GetSafeDirDefaultExternal("")
	kvs.Initialize(shared, "Userdatastore")
	If SQL1.IsInitialized = False Then
		SQL1.Initialize(shared, "kledb.db", False)
	End If
	
	ScrollView1.FullScroll(True)
	ScrollView1.Panel.LoadLayout("lyCustomerDetail2")
	ScrollView1.Panel.Height = 700dip
	
	cboCustomerLevel.Add ("Customer")
	cboCustomerLevel.Add ("Dealer")
	cboCustomerLevel.Add ("Master Dealer")
	
	Dim CursorLocation As Cursor
	CursorLocation = SQL1.ExecQuery("SELECT * FROM Location ORDER BY LocationName")
	For i = 0 To CursorLocation.RowCount - 1
		CursorLocation.Position = i
		cboLocation.Add(CursorLocation.GetString("LocationName"))
	Next
	
	SelectedCustomerID = kvs.Get("SelectedCustomerID")
	If SelectedCustomerID = "" Then
		Action = "ADD"
		'Generate Customer Code
		txtCustomerCode.Text = getCustomerCode
	Else
		Action = "EDIT"
		kvs.Put("SelectedCustomerID","")
		'Load Detail
		LoadDetail
	End If
	
	If kvs.Get("CURRUSERADMIN") = "YES" Then
		btnSave.Enabled = True
	Else If kvs.Get("CURRUSERADMIN") = "NO" Then
		btnSave.Enabled = False
	Else
		btnSave.Enabled = False
	End If
	
End Sub

Sub Activity_Resume

End Sub

Sub Activity_Pause (UserClosed As Boolean)

End Sub

Sub btnBack_Click
		
	Activity.Finish
	
End Sub

Sub LoadDetail

	cursor1 = SQL1.ExecQuery("SELECT * FROM CUSTOMER WHERE Status = 1 AND ID = " & SelectedCustomerID )
	If cursor1.RowCount > 0 Then
		cursor1.Position = 0
	
		If cursor1.GetString ("CustomerLevel").ToUpperCase  = "MASTER DEALER" Then
			cboCustomerLevel.SelectedIndex = 2
		Else If cursor1.GetString ("CustomerLevel").ToUpperCase = "DEALER" Then
			cboCustomerLevel.SelectedIndex = 1
		Else If cursor1.GetString ("CustomerLevel").ToUpperCase = "CUSTOMER" Then
			cboCustomerLevel.SelectedIndex = 0
		End If
		
		CustomerCode = cursor1.GetString ("CustomerCode")
		txtCustomerCode.Text = cursor1.GetString ("CustomerCode")
		txtCustomerName.Text =  cursor1.GetString ("CustomerName")
		txtAddress1.Text =  cursor1.GetString ("Address1")
		txtAddress2.Text =  cursor1.GetString ("Address2")
		txtAddress3.Text =  cursor1.GetString ("Address3")
		txtAddress4.Text =  cursor1.GetString ("Address4")
		txtPhoneNo.Text =  cursor1.GetString ("Telephone")
		txtFaxNo.Text =  cursor1.GetString ("FaxNo")
		txtContactPerson.Text =  cursor1.GetString ("ContactPerson")
		txtMobileNo.Text =  cursor1.GetString ("MobileNo")
		txtEmail.Text =  cursor1.GetString ("Email")
		txtLng.Text = cursor1.GetString ("Lng")
		txtLat.Text = cursor1.GetString ("Lat")
		'txtBarcode.Text  =cursor1.GetString ("Barcode")
		cboLocation.SelectedIndex = cboLocation.IndexOf(cursor1.GetString ("Location"))
		
	End If
	
	
End Sub

Sub getCustomerCode () As String

	Dim intCount As Int
	dtCode = SQL1.ExecQuery("SELECT COUNT(ID) AS QTY FROM Customer")
	dtCode.Position = 0
	intCount = dtCode.GetInt ("QTY")
	intCount = 1000 + intCount +1
	Return intCount
	
End Sub

Sub btnSave_Click

'	'Validate
	If txtCustomerName.Text = "" Then
		Msgbox("Please Fill In Customer Name","Error")
		Return
	End If
		
	Dim str As String
	
	If Action = "ADD" Then

		str = "INSERT INTO CUSTOMER(CustomerCode, CustomerName, Address1, Address2, Address3, Address4, "
		str = str & "ContactPerson, Telephone, FaxNo, MobileNo, Email, CustomerLevel, Lng, Lat, Location) VALUES ( "
		str = str & "'" & txtCustomerCode.Text & "',"
		str = str & "'" & txtCustomerName.Text & "',"
		str = str & "'" & txtAddress1.Text & "',"
		str = str & "'" & txtAddress2.Text & "',"
		str = str & "'" & txtAddress3.Text & "',"
		str = str & "'" & txtAddress4.Text & "',"
		str = str & "'" & txtContactPerson.Text & "',"
		str = str & "'" & txtPhoneNo.Text & "',"
		str = str & "'" & txtFaxNo.Text & "',"
		str = str & "'" & txtMobileNo.Text & "',"
		str = str & "'" & txtEmail.Text & "',"
		str = str & "'" & cboCustomerLevel.SelectedItem & "',"
		str = str & "'" & txtLng.Text & "',"
		str = str & "'" & txtLat.Text & "',"
		str = str & "'" & cboLocation.SelectedItem & "'"
		str = str & ")"
	Else If Action = "EDIT" Then
		str = "UPDATE CUSTOMER SET CustomerCode = '" & txtCustomerCode.Text & "',"
		str = str & "CustomerName = '" & txtCustomerName.Text & "',"
		str = str & "Address1 = '" & txtAddress1.Text & "',"
		str = str & "Address2 = '" & txtAddress2.Text  & "',"
		str = str & "Address3 = '" & txtAddress3.Text  & "',"
		str = str & "Address4 = '" & txtAddress4.Text  & "',"
		str = str & "ContactPerson = '" & txtContactPerson.Text  & "',"
		str = str & "Telephone = '" & txtPhoneNo.Text  & "',"
		str = str & "FaxNo = '" & txtFaxNo.Text  & "',"
		str = str & "MobileNo = '" & txtMobileNo.Text  & "',"
		str = str & "Email = '" & txtEmail.Text  & "',"
		str = str & "CustomerLevel = '" & cboCustomerLevel.SelectedItem & "',"
		str = str & "Lng ='" & txtLng.Text & "',"
		str = str & "Lat ='" & txtLat.Text & "',"
		str = str & "Location ='" & cboLocation.SelectedItem & "'"
		str = str & " WHERE ID = " & SelectedCustomerID
		'str = str & ")"
	End If

	
	SQL1.ExecNonQuery(str)
	
	MsgboxAsync("Save Successfully","OK")
	Wait For Msgbox_Result(Result As Int)
	Activity.Finish
			
	
End Sub

