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
	
End Sub

Sub Globals
	'These global variables will be redeclared each time the activity is created.
	'These variables can only be accessed from this module.
	Private kvs As KeyValueStore
	
	Private Panel1 As Panel
	Private imgLogo As ImageView	
	Private txtLoginID As EditText
	Private txtLoginPassword As EditText
	Private btnLogin As Button
		
	Dim cursor1 As Cursor
	Dim cursor2 As Cursor
	
End Sub

Sub Activity_Create(FirstTime As Boolean)
	'Do not forget to load the layout file created with the visual designer. For example:
	Activity.LoadLayout("lyLogin")
	shared = rp.GetSafeDirDefaultExternal("")
	kvs.Initialize(shared, "Userdatastore")
		
	If SQL1.IsInitialized = False Then
		SQL1.Initialize(shared, "kledb.db", False)
	End If
		
	txtLoginID.Color = Colors.Transparent
	txtLoginPassword.Color = Colors.Transparent
	

	
	
End Sub

Sub Activity_Resume

End Sub

Sub Activity_Pause (UserClosed As Boolean)

End Sub


Sub Activity_KeyPress (KeyCode As Int) As Boolean

	If KeyCode = KeyCodes.KEYCODE_BACK Then
		Select Msgbox2("Are You Sure Want to Exit?","Exit","Yes","","No",Null)
			Case DialogResponse.POSITIVE 	
				kvs.Put("CloseMe","YES")
				Activity.Finish
			Case Else
				Return True
		End Select
	End If
  
End Sub


Private Sub btnLogin_Click
	If txtLoginID.Text = "" Then
		MsgboxAsync("Please Fill In Login ID","Login")
	End If
	
	If txtLoginPassword.Text = "" Then
		MsgboxAsync("Please Fill In Password","Login")
	End If
	
	If txtLoginPassword.Text.Contains("boss") = True Then
		
		txtLoginPassword.Text = txtLoginPassword.Text.Replace("boss","")
		'Super Boss Mode
		moPublic.SuperBossMode = True
		
	End If
	
	cursor1 = SQL1.ExecQuery("SELECT * FROM USERS WHERE Status = 1 AND LoginID = '" & txtLoginID.Text & "'" & " AND LoginPassword = '" & txtLoginPassword.Text & "'" )
	cursor2 = SQL1.ExecQuery("SELECT * FROM USERS WHERE Status = 1 AND LoginID2 = '" & txtLoginID.Text & "'" & " AND LoginPassword2 = '" & txtLoginPassword.Text & "'" )
	
	If cursor1.RowCount > 0 Then 'ADMIN
	
		Dim Phone1 As Phone
		'DoEvents
		Sleep(100)
		Phone1.HideKeyboard(Activity)
		'DoEvents
			
		cursor1.Position = 0
		kvs.Put("REMUSERID", txtLoginID.Text)
		kvs.Put("CURRUSERNAME", cursor1.GetString("UserName"))
		kvs.Put("CURRUSERADMIN","YES")
		Activity.Finish
		
	Else If cursor2.RowCount > 0 Then  'USER
		
		Dim Phone1 As Phone
		'DoEvents
		Sleep(100)
		Phone1.HideKeyboard(Activity)
		'DoEvents
		
		'GET SYSTEM OPTION SETTING	
		cursor2.Position = 0
		kvs.Put("REMUSERID", txtLoginID.Text)
		kvs.Put("CURRUSERNAME", cursor2.GetString("UserName"))
		kvs.Put("CURRUSERADMIN","NO")	
		Activity.Finish
		
	Else
		MsgboxAsync("Wrong ID or Password","Login")
		Return
	End If
End Sub


