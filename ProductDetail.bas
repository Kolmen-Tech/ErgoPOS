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
	Private rp As RuntimePermissions
	Private shared As String
	Dim SQL1 As SQL
	Dim cursor1 As Cursor
	Dim cursorProductCategory As Cursor
End Sub

Sub Globals
	'These global variables will be redeclared each time the activity is created.
	'These variables can only be accessed from this module.
	Private kvs As KeyValueStore
	Dim cboGSTCode As Spinner
	Dim txtProductCode As EditText
	Dim txtProductName As EditText
	Dim txtUnitPrice As EditText
	Dim txtUnitPrice2 As EditText
	Dim txtUnitPrice3 As EditText
	Dim txtRemarks As EditText
	Dim txtBarcode As EditText
	
	Dim SelectedItemID As String
	Dim Action As String
	Private btnSave As Button
	'Dim sc As Zxing_B4A
	
	
	Private cboProductCategory As Spinner
	Private txtCost As EditText
	Private ImageView10 As ImageView
End Sub

Sub Activity_Create(FirstTime As Boolean)
	'Do not forget to load the layout file created with the visual designer. For example:
	Activity.LoadLayout("lyProductDetail")
	shared = rp.GetSafeDirDefaultExternal("")
	kvs.Initialize(shared, "Userdatastore")
	If SQL1.IsInitialized = False Then
		SQL1.Initialize(shared, "kledb.db", False)
	End If
	LoadProductCategory
	
	'Load Tax Code
	LoadTaxCode
	
	SelectedItemID = kvs.Get("SelectedItemID")
	If SelectedItemID = "" Then
		Action = "ADD"
		txtCost.Text = 0
	Else
		Action = "EDIT"
		kvs.Put("SelectedItemID","")
		'Load Detail
		LoadDetail
	End If
	
	If kvs.Get("CURRUSERADMIN") = "YES" Then
		btnSave.Enabled = True
	Else If kvs.Get("CURRUSERADMIN") = "NO" Then
		btnSave.Enabled = False
	Else
		btnSave.Enabled = True
	End If
	
	If moPublic.SuperBossMode = False Then
		txtCost.Visible = False
		ImageView10.Visible = False
	End If
End Sub

Sub Activity_Resume

End Sub

Sub Activity_Pause (UserClosed As Boolean)

End Sub

Sub LoadProductCategory
	
	cursorProductCategory = SQL1.ExecQuery("SELECT * FROM ProductCategory WHERE Status = 1 ORDER BY Category")
	
	For i = 0 To cursorProductCategory.RowCount -1
		cursorProductCategory.Position = i
		cboProductCategory.Add(cursorProductCategory.GetString ("Category"))
	Next
		
End Sub

Sub LoadTaxCode
	
	cursor1 = SQL1.ExecQuery("SELECT * FROM TaxCode ORDER BY Tax")
	
	For i = 0 To cursor1.RowCount -1
		cursor1.Position = i
		cboGSTCode.Add(cursor1.GetString ("CodeName"))
	Next
		
End Sub

Sub LoadDetail
	cursor1 = SQL1.ExecQuery("SELECT * FROM ITEMS WHERE Status = 1 AND ID = " & SelectedItemID  )
	If cursor1.RowCount > 0 Then
		cursor1.Position = 0
		cboProductCategory.SelectedIndex = cboProductCategory.IndexOf(cursor1.GetString ("Category"))
		cboGSTCode.SelectedIndex = cboGSTCode.IndexOf(cursor1.GetString ("GSTCode"))
		txtProductCode.Text  = cursor1.GetString ("ItemCode")
		txtProductName.Text  =cursor1.GetString ("ItemName")
		txtUnitPrice.Text = NumberFormat2 (cursor1.GetDouble ("UnitPrice"),0,2,2,False)
		txtUnitPrice2.Text = NumberFormat2 (cursor1.GetDouble ("UnitPrice2"),0,2,2,False)
		txtUnitPrice3.Text = NumberFormat2 (cursor1.GetDouble ("UnitPrice3"),0,2,2,False)
		txtRemarks.Text  =cursor1.GetString ("Remarks")
		txtBarcode.Text  =cursor1.GetString ("Barcode")
		txtCost.Text = NumberFormat2 (cursor1.GetDouble ("Cost"),0,2,2,False)
		
	End If
End Sub


Sub btnSave_Click

	'Validate
	If txtProductCode.Text = "" Then
		Msgbox("Please Fill In Product Code","Error")
		Return
	End If
	
	If txtProductName.Text = "" Then
		Msgbox("Please Fill In Product Name","Error")
		Return
	End If
	
	If txtProductName.Text.Contains ("'") Then
		Msgbox("Peoduct Name Invalid Char","Error")
		Return
	End If
	
	If txtUnitPrice.Text = "" Then
		Msgbox("Please Fill In Unit Price","Error")
		Return
	End If
	
	If txtUnitPrice2.Text = "" Then
		Msgbox("Please Fill In Unit Price 2","Error")
		Return
	End If
	
	If txtUnitPrice3.Text = "" Then
		Msgbox("Please Fill In Unit Price 3","Error")
		Return
	End If
	
	If txtCost.Text = "" Then
		Msgbox("Please Fill In Cost","Error")
		Return
	End If
	
	
	Dim str As String
	
	If Action = "ADD" Then
		str = "INSERT INTO ITEMS(ItemCode, ItemName, UnitPrice, UnitPrice2, UnitPrice3, GSTCode, ImageDIR, Barcode, Remarks, Category, Cost ) VALUES ( "
		str = str & "'" & txtProductCode.Text & "',"
		str = str & "'" & txtProductName.Text & "',"
		str = str & "'" & txtUnitPrice.Text & "',"
		str = str & "'" & txtUnitPrice2.Text & "',"
		str = str & "'" & txtUnitPrice3.Text & "',"
		str = str & "'" & cboGSTCode.SelectedItem & "',"
		str = str & "'" & "',"
		str = str & "'" & txtBarcode.Text & "',"
		str = str & "'" & txtRemarks.Text & "',"
		str = str & "'" & cboProductCategory.SelectedItem & "',"
		str = str & "'" & txtCost.Text & "'"
		str = str & ")"
	Else If Action = "EDIT" Then
		str = "UPDATE ITEMS SET ItemCode = '" & txtProductCode.Text & "',"
		str = str & "ItemName = '" & txtProductName.Text & "',"
		str = str & "UnitPrice = '" & txtUnitPrice.Text & "',"
		str = str & "UnitPrice2 = '" & txtUnitPrice2.Text & "',"
		str = str & "UnitPrice3 = '" & txtUnitPrice3.Text & "',"
		str = str & "GSTCode = '" & cboGSTCode.SelectedItem  & "',"
		str = str & "ImageDIR = '" & "',"
		str = str & "Barcode = '" & txtBarcode.Text  & "',"
		str = str & "Remarks = '" & txtRemarks.Text  & "',"
		str = str & "Category = '" & cboProductCategory.SelectedItem  & "',"
		str = str & "Cost = '" & txtCost.Text  & "'"
		str = str & " WHERE ID = " & SelectedItemID
		'str = str & ")"
	End If

	
	SQL1.ExecNonQuery(str)
		
	MsgboxAsync("Save Successfully","OK")
	Wait For Msgbox_Result(Result As Int)
	Activity.Finish
	
End Sub


Sub btnScan_Click
	'sc.BeginScan("sc")
End Sub



Sub btnBack_Click
	
	Activity.Finish
	
End Sub

