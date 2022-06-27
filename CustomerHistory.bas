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
	Private btnBack As Button
	Private clv1 As CustomListView
	Dim dtID As Int
	Dim strLine1 As String
	Dim strLine2 As String
End Sub

Sub Activity_Create(FirstTime As Boolean)
	'Do not forget to load the layout file created with the visual designer. For example:
	Activity.LoadLayout("lyCustomerHistory")
	shared = rp.GetSafeDirDefaultExternal("")
	kvs.Initialize(shared, "Userdatastore")
	If SQL1.IsInitialized = False Then
		SQL1.Initialize(shared, "kledb.db", False)
	End If
End Sub

Sub Activity_Resume
	RefreshGrid
End Sub

Sub Activity_Pause (UserClosed As Boolean)

End Sub

Sub RefreshGrid
	clv1.Clear
	ProgressDialogShow("Loading Data...")
	Dim strDate, strTime As String
'	
'	Dim DateFrom As Long
'	Dim DateTo As Long
'	DateTime.DateFormat = "dd/MM/yyyy"
	
	cursor1 = SQL1.ExecQuery("SELECT * FROM TTMaster WHERE Status = 1 AND CustomerID = " & kvs.Get("SelectedCustomerID") & " ORDER BY TTDATE DESC")
	
	For i = 0 To cursor1.RowCount - 1
		cursor1.Position = i
		strDate  = DateTime.GetDayOfMonth((cursor1.GetString("TTDate"))) & "/" & DateTime.GetMonth((cursor1.GetString("TTDate"))) & "/" & DateTime.GetYear((cursor1.GetString("TTDate")))
		DateTime.TimeFormat = "KK:mm:ss a"
		strTime = DateTime.Time(cursor1.GetString("TTTime"))
		
		dtID = cursor1.getString("ID")
		strLine1 = cursor1.getString("CustomerName")
		strLine2 = cursor1.getString("MasterCode") & " | " & "RM " & NumberFormat2(cursor1.getString("TotalAmtIncGST"),0,2,2,False)
		strLine2 = strLine2 & " | " &  strDate & " " & strTime
		clv1.Add(CreateListItem(strLine1,strLine2,clv1.AsView.Width, 50dip), dtID)
		
	Next
		 
	ProgressDialogHide
End Sub

Sub CreateListItem( Line1 As String, Line2 As String, Width As Int, Height As Int) As Panel
	Dim p As Panel
	p.Initialize("")
	p.Color = Colors.White
	
	Dim chkSelect As CheckBox
	chkSelect.Initialize ("")
	
		
	Dim lblLine1 As Label
	lblLine1.Initialize("")
	lblLine1.Text = Line1
	lblLine1.Textsize = 17
	lblLine1.TextColor = Colors.RGB (37,160,255)
 
	Dim lblLine2 As Label
	lblLine2.Initialize("")
	lblLine2.Text = Line2
	lblLine2.Textsize = 14
	lblLine2.TextColor = Colors.DarkGray
	
	p.AddView (chkSelect, 5dip, 10dip, 35dip,30dip)   '#0
	p.AddView (lblLine1, 50dip, 5dip, 100%x - 75dip,25dip)  '#1
	p.AddView (lblLine2, 50dip, 25dip , 100%x - 85dip ,20dip)  '#2
	
	Return p
	
End Sub


Sub btnBack_Click
	Activity.Finish
End Sub

Sub clv1_ItemClick (Index As Int, Value As Object)
	kvs.Put("SelectedDocID",Value)
	StartActivity("DocDetail")
End Sub

