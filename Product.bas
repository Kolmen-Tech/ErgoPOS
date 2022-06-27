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
	'Dim dtID As Int
	
	'SYSTEM SETTING
	Dim strCurrencySymbol As String
	Private btnDelete As Button
	Private chkSelect As CheckBox
	Private lblLine1 As Label
	Private lblLine2 As Label
End Sub

Sub Activity_Create(FirstTime As Boolean)
	'Do not forget to load the layout file created with the visual designer. For example:
	Activity.LoadLayout("lyProduct")
	shared = rp.GetSafeDirDefaultExternal("")
	kvs.Initialize(shared, "Userdatastore")
	If SQL1.IsInitialized = False Then
		SQL1.Initialize(shared, "kledb.db", False)
	End If
	
	'GET Currency
	strCurrencySymbol = kvs.Get("CurrencySimbol")

	If FirstTime = True Then
		RefreshGrid
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

Sub clv1_ItemClick (Index As Int, Value As Object)

	kvs.Put("SelectedItemID",Value)
	StartActivity("ProductDetail")

End Sub

Sub RefreshGrid

	clv1.Clear
	ProgressDialogShow("Loading Data...")
	cursor1 = SQL1.ExecQuery("SELECT * FROM ITEMS WHERE Status = 1 ORDER BY ItemCode")
	For i = 0 To cursor1.RowCount - 1
		cursor1.Position = i
		dtID = cursor1.getString("ID")
		If cursor1.getString("ItemName").Trim <> "" Then
			strLine1 = cursor1.getString("ItemName")
			strLine2 = cursor1.getString("ItemCode") &  "  " & strCurrencySymbol & " | " & NumberFormat2(cursor1.getString("UnitPrice")	,0,2,2,False)
			strLine2 = strLine2 & " | " &  NumberFormat2(cursor1.getString("UnitPrice2")	,0,2,2,False)
			strLine2 = strLine2 & " | " &  NumberFormat2(cursor1.getString("UnitPrice3")	,0,2,2,False)
			clv1.Add(CreateListItem(strLine1,strLine2,clv1.AsView.Width, 60dip), dtID)
		End If
	
	Next
	
	 
	ProgressDialogHide
	
End Sub

Sub CreateListItem( Line1 As String, Line2 As String, Width As Int, Height As Int) As Panel

	Dim p As Panel
	p.Initialize("")
	'we need to add the panel to a parent to set its dimensions. It will be removed after the layout is loaded.
	Activity.AddView(p, 0, 0, Width, Height)
	p.LoadLayout("lyProductListDetail")
	p.RemoveView
	'label1 and button1 will point to the last added views.
	lblLine1.Text = Line1
	lblLine2.Text = Line2
	
	Return p
	
End Sub

Sub btnAdd_Click
	StartActivity("ProductDetail")
End Sub

Sub btnBack_Click
	
	Activity.Finish
	
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
				SQL1.ExecNonQuery("DELETE FROM ITEMS WHERE ID = " & dtID  )
				'Msgbox(clv1.GetValue (i),"Value")
			End If
		Next
		
		RefreshGrid
		
	Else If i=DialogResponse.NEGATIVE Then   'do No code
		Return
	End If
	
End Sub
