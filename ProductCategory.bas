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
	Private btnBack As Button
	Private btnDelete As Button
	Private btnAdd As Button
	Private lblName As Label
	Private chkSelect As CheckBox
	Dim pnl As Panel
End Sub

Sub Activity_Create(FirstTime As Boolean)
	'Do not forget to load the layout file created with the visual designer. For example:
	Activity.LoadLayout("lyProductCategory")
	shared = rp.GetSafeDirDefaultExternal("")
	kvs.Initialize(shared, "Userdatastore")
	If SQL1.IsInitialized = False Then
		SQL1.Initialize(shared, "kledb.db", False)
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
	RefreshGrid
End Sub

Sub Activity_Pause (UserClosed As Boolean)

End Sub

Sub RefreshGrid
	
	Dim dtID As Int
	Dim dtCategoryName As String
	
	clv1.Clear
	ProgressDialogShow("Loading Data...")
	cursor1 = SQL1.ExecQuery("SELECT * FROM ProductCategory WHERE Status = 1 ORDER BY Category")
	For i = 0 To cursor1.RowCount - 1
		cursor1.Position = i
		dtID = cursor1.getString("ID")
		dtCategoryName = cursor1.getString("Category")
		clv1.Add(CreateListItem(dtCategoryName,clv1.AsView.Width, 50dip),dtID)
	Next
	 
	ProgressDialogHide
	
End Sub

Sub CreateListItem(Name As String, Width As Int, Height As Int) As Panel
	Dim p As Panel
	p.Initialize("")
	'we need to add the panel to a parent to set its dimensions. It will be removed after the layout is loaded.
	Activity.AddView(p, 0, 0, Width, Height)
	p.LoadLayout("lyProductCategoryListDetail")
	p.RemoveView
	'label1 and button1 will point to the last added views.
	lblName.Text = Name
	Return p
	
End Sub


Sub btnBack_Click
	Activity.Finish
End Sub

Sub btnDelete_Click
	Dim i As Int
	i = Msgbox2("Are You Sure Want To Delete ?","Delete", "Yes", "", "No", Null)
	Dim chk As CheckBox
	Dim dtID As Int
	If i=DialogResponse.POSITIVE Then   'do Yes code
		For i = 0 To clv1.GetSize -1
			pnl = clv1.GetPanel(i)
			chk = pnl.GetView(1)
			If chk.Checked = True Then
				dtID = clv1.GetValue(i)
				SQL1.ExecNonQuery("UPDATE ProductCategory SET Status = 0 WHERE ID = " & dtID  )
				'Msgbox(clv1.GetValue (i),"Value")
			End If
		Next
		
		RefreshGrid
		
	Else If i=DialogResponse.NEGATIVE Then   'do No code
		Return
	End If
End Sub

Sub btnAdd_Click
	
	StartActivity("ProductCategoryDetail")
	
End Sub

Sub clv1_ItemClick (Index As Int, Value As Object)
	kvs.Put ("SelectedProductCategoryID",Value)
	StartActivity("ProductCAtegoryDetail")
End Sub
