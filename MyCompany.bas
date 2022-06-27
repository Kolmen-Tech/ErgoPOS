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
	Private rp As RuntimePermissions
	Private shared As String
End Sub

Sub Globals
	'These global variables will be redeclared each time the activity is created.
	'These variables can only be accessed from this module.
	Private kvs As KeyValueStore
	Dim btnBack As Button
	Dim btnSave As Button
	
	Dim txtCompanyName As EditText
	Dim txtAddress1 As EditText
	Dim txtAddress2 As EditText
	Dim txtAddress3 As EditText
	Dim txtAddress4 As EditText
	Dim txtPhoneNo As EditText
	Dim txtFaxNo As EditText
	Dim txtWebsite As EditText
	Dim txtEmail As EditText
	Dim txtGSTNo As EditText
	Dim txtRegNo As EditText
	Dim txtFooter As EditText
	Dim txtBranchName As EditText
	
	Private txtMerchantCode As EditText
End Sub

Sub Activity_Create(FirstTime As Boolean)
	'Do not forget to load the layout file created with the visual designer. For example:
	Activity.LoadLayout("lyMyCompany")
	shared = rp.GetSafeDirDefaultExternal("")
	kvs.Initialize(shared, "Userdatastore")
	If SQL1.IsInitialized = False Then
		SQL1.Initialize(shared, "kledb.db", False)
	End If
	LoadDetail

End Sub

Sub Activity_Resume

End Sub

Sub Activity_Pause (UserClosed As Boolean)

End Sub

Sub LoadDetail

	cursor1 = SQL1.ExecQuery("SELECT * FROM MYCOMPANY WHERE ID = 1 " )
	If cursor1.RowCount > 0 Then
		cursor1.Position = 0
	
		txtCompanyName.Text = cursor1.GetString ("CompanyName")
		txtAddress1.Text = cursor1.GetString ("Address1")
		txtAddress2.Text  = cursor1.GetString ("Address2")
		txtAddress3.Text = cursor1.GetString ("Address3")
		txtAddress4.Text = cursor1.GetString ("Address4")
		txtPhoneNo.Text = cursor1.GetString ("PhoneNo")
		txtFaxNo.Text = cursor1.GetString ("FaxNo")
		txtWebsite.Text = cursor1.GetString ("Website")
		txtEmail.Text = cursor1.GetString ("Email")
		txtGSTNo.Text = cursor1.GetString ("GSTNo")
		txtRegNo.Text = cursor1.GetString ("RegNo")
		txtFooter.Text = cursor1.GetString ("Footer")
		txtBranchName.Text = cursor1.GetString ("Branch")
	
	End If
	
	If kvs.ContainsKey("MerchantCode") = False Then
		kvs.Put("MerchantCode","0")
		txtMerchantCode.Text = "0"
	Else
		txtMerchantCode.Text = kvs.Get("MerchantCode")
	End If
	
	
End Sub

Sub btnBack_Click
	
	Activity.Finish
	
End Sub


Sub btnSave_Click
		
	Dim str As String

	str = "UPDATE MYCOMPANY SET "
	str = str & "CompanyName = '" & txtCompanyName.Text & "',"
	str = str & "Address1 = '" & txtAddress1.Text & "',"
	str = str & "Address2 = '" & txtAddress2.Text  & "',"
	str = str & "Address3 = '" & txtAddress3.Text  & "',"
	str = str & "Address4 = '" & txtAddress4.Text  & "',"
	str = str & "PhoneNo = '" & txtPhoneNo.Text  & "',"
	str = str & "FaxNo = '" & txtFaxNo.Text  & "',"
	str = str & "Website = '" & txtWebsite.Text  & "',"
	str = str & "Email = '" & txtEmail.Text  & "',"
	str = str & "GSTNo = '" & txtGSTNo.Text  & "',"
	str = str & "RegNo = '" & txtRegNo.Text  & "',"
	str = str & "Branch = '" & txtBranchName.Text  & "',"
	str = str & "Footer = '" & txtFooter.Text  & "'"
	str = str & " WHERE ID = 1"
		
	SQL1.ExecNonQuery(str)	
	kvs.Put("MerchantCode",txtMerchantCode.Text)
	MsgboxAsync("Save Successfully","OK")
	Wait For Msgbox_Result(Result As Int)	
	Activity.Finish

	
			
	
End Sub
