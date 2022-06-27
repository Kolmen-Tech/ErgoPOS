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
	Dim SelectedCategoryID As String
	Dim Action As String
	Private btnSave As Button
	Private btnBack As Button
	Private txtCategoryName As EditText
End Sub

Sub Activity_Create(FirstTime As Boolean)
	'Do not forget to load the layout file created with the visual designer. For example:
	Activity.LoadLayout("lyProductCategoryDetail")
	shared = rp.GetSafeDirDefaultExternal("")
	kvs.Initialize(shared, "Userdatastore")
	If SQL1.IsInitialized = False Then
		SQL1.Initialize(shared, "kledb.db", False)
	End If
	
	SelectedCategoryID = kvs.Get("SelectedProductCategoryID")
	If SelectedCategoryID = "" Then
		Action = "ADD"
	Else
		Action = "EDIT"
		kvs.Put("SelectedProductCategoryID","")
		'Load Detail
		LoadDetail
	End If

End Sub

Sub Activity_Resume

End Sub

Sub Activity_Pause (UserClosed As Boolean)

End Sub

Sub LoadDetail
	cursor1 = SQL1.ExecQuery("SELECT * FROM ProductCategory WHERE Status = 1 AND ID = " & SelectedCategoryID )
	If cursor1.RowCount > 0 Then
		cursor1.Position = 0
		txtCategoryName.Text = cursor1.GetString ("Category")
	End If
End Sub

Sub btnSave_Click
	If txtCategoryName.Text = "" Then
		MsgboxAsync("Please Fill In Customer Name","Error")
		Return
	End If
		
	Dim str As String
	
	If Action = "ADD" Then
		str = "INSERT INTO ProductCategory(Category, Status "
		str = str & ") VALUES ( "
		str = str & "'" & txtCategoryName.Text & "',"
		str = str & "1"
		str = str & ")"
	Else If Action = "EDIT" Then
		str = "UPDATE ProductCategory SET Category = '" & txtCategoryName.Text & "' "
		str = str & " WHERE ID = " & SelectedCategoryID
		'str = str & ")"
	End If

	Dim Phone1 As Phone
	Sleep(100)
	Phone1.HideKeyboard(Activity)
	
	SQL1.ExecNonQuery(str)
	MsgboxAsync("Save Successfully","OK")
	Wait For Msgbox_Result(Result As Int)
	Activity.Finish
	
End Sub

Sub btnBack_Click
	Activity.Finish
End Sub
