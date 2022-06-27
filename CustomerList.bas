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
	Dim clv1 As CustomListView
	Dim lblTitle As Label
	Dim PanelBottom As Panel
	Dim btnBack As Button
	
	Dim dtID As Int
	Dim strLine1 As String
	Dim strLine2 As String
	
	Dim pnl As Panel
	Dim chk As CheckBox
	
	Private btnDelete As Button
	Private Panel1 As Panel
	Private chkShowAll As CheckBox
	Private btnSearch As Button
	Private txtName As EditText
	Private chkSelect As CheckBox
	Private lblLine1 As Label
	Private lblLine2 As Label
	Private btnHistory As Button
End Sub

Sub Activity_Create(FirstTime As Boolean)
	'Do not forget to load the layout file created with the visual designer. For example:
	'Activity.LoadLayout("Layout1")
	Activity.LoadLayout("lyCustomerList")
	shared = rp.GetSafeDirDefaultExternal("")
	kvs.Initialize(shared, "Userdatastore")
	If SQL1.IsInitialized = False Then
		SQL1.Initialize(shared, "kledb.db", False)
	End If
	
	If kvs.ContainsKey("ShowAllCustomer") = False Then
		kvs.Put("ShowAllCustomer","YES")
	End If
	
	If kvs.Get("ShowAllCustomer") = "YES" Then
		chkShowAll.Checked = True
	Else
		chkShowAll.Checked = False
	End If
	
	If kvs.Get("CURRUSERADMIN") = "YES" Then
		btnDelete.Enabled = True
	Else If kvs.Get("CURRUSERADMIN") = "NO" Then
		btnDelete.Enabled = False
	Else
		btnDelete.Enabled = True
	End If
	
End Sub

Sub Activity_Resume
	If chkShowAll.Checked = True Then
		RefreshGrid
	End If
End Sub

Sub Activity_Pause (UserClosed As Boolean)

End Sub

Sub btnBack_Click
	
	Activity.Finish
	
End Sub

Sub clv1_ItemClick (Index As Int, Value As Object)

	kvs.Put ("SelectedCustomerID",Value)
	StartActivity("CustomerDetail")

End Sub

Sub CreateListItem( ID As Int, Line1 As String, Line2 As String, Width As Int, Height As Int) As Panel
	
	Dim p As Panel
	p.Initialize("")
	p.SetLayout(0, 0, Width, Height)
	p.LoadLayout("lyCustomerListDetail")

	lblLine1.Text = Line1
	lblLine2.Text = Line2
	btnHistory.Tag = ID
	
	Return p
	
End Sub

Sub RefreshGrid
	
	clv1.Clear
	ProgressDialogShow("Loading Data...")
	cursor1 = SQL1.ExecQuery("SELECT * FROM CUSTOMER WHERE Status = 1 ORDER BY CustomerName")
		
	For i = 0 To cursor1.RowCount - 1
		cursor1.Position = i
		dtID = cursor1.getString("ID")
		strLine1 = cursor1.getString("CustomerName") & "(" & cursor1.getString("CustomerLevel") & ")"
		strLine2 = cursor1.getString("Address1") & " " & cursor1.getString("Address2") & " " & cursor1.getString("Address3") & " " & cursor1.getString("Address4")
		clv1.Add(CreateListItem(dtID, strLine1,strLine2,clv1.AsView.Width, 70dip),  dtID)
	Next
	
	 
	ProgressDialogHide
	
End Sub

Sub RefreshGrid_Search(Param As String)
	
	clv1.Clear
	ProgressDialogShow("Loading Data...")
	cursor1 = SQL1.ExecQuery("SELECT * FROM CUSTOMER WHERE Status = 1 AND CustomerName LIKE '%" & Param & "%'" & " ORDER BY CustomerName")
		
	For i = 0 To cursor1.RowCount - 1
		cursor1.Position = i
		dtID = cursor1.getString("ID")
		strLine1 = cursor1.getString("CustomerName") & "(" & cursor1.getString("CustomerLevel") & ")"
		strLine2 = cursor1.getString("Address1") & " " & cursor1.getString("Address2") & " " & cursor1.getString("Address3") & " " & cursor1.getString("Address4")
		
		clv1.Add(CreateListItem(dtID, strLine1,strLine2,clv1.AsView.Width, 70dip), dtID)
	Next
	
	 
	ProgressDialogHide
	
End Sub





Sub btnAdd_Click
	StartActivity("CustomerDetail")
End Sub

Sub btnDelete_Click
	Dim i As Int
	i = Msgbox2("Are You Sure Want To Delete ?","Delete", "Yes", "", "No", Null)
	If i=DialogResponse.POSITIVE Then   'do Yes code
		For i = 0 To clv1.GetSize -1
			pnl = clv1.GetPanel(i)
			chk = pnl.GetView(0)
			If chk.Checked = True Then
				dtID = clv1.GetValue(i)
				SQL1.ExecNonQuery("DELETE FROM CUSTOMER WHERE ID = " & dtID  )
				'Msgbox(clv1.GetValue (i),"Value")
			End If
		Next
		
		If chkShowAll.Checked = True Then
			RefreshGrid
		End If
		
	Else If i=DialogResponse.NEGATIVE Then   'do No code
		Return
	End If
	
End Sub




Sub chkShowAll_CheckedChange(Checked As Boolean)
	If chkShowAll.Checked = True Then
		kvs.Put("ShowAllCustomer","YES")
	Else
		kvs.Put("ShowAllCustomer","NO")
	End If
	
	
End Sub

Sub btnSearch_Click
	
	Dim Phone1 As Phone
	'DoEvents
	Sleep(100)
	Phone1.HideKeyboard(Activity)
	
	If txtName.Text = "" Then
		RefreshGrid
	Else
		RefreshGrid_Search(txtName.Text)
	End If
	
	
	
End Sub

Sub btnHistory_Click
	
	Dim index As Int = clv1.GetItemFromView(Sender)
	'InputDiscount(index)
	
	pnl = clv1.GetPanel(index)
	Dim btn As Button
	btn = pnl.GetView(3)
	Dim SelectedCustomerID As Int
	SelectedCustomerID = btn.Tag
	Log("SelectedCustomerID:" & SelectedCustomerID)
	kvs.Put("SelectedCustomerID",SelectedCustomerID)
	StartActivity("CustomerHistory")
	
	
	
End Sub
