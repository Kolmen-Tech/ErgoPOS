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
	Private LastIntent As Intent
	Private kvs As KeyValueStore
	Dim cboTTDateFrom As xnEditDate
	Dim cboTTDateTo As xnEditDate
	Dim PanelCenter As Panel
	Dim Label1, Label2 As Label
	Dim btnSearch As Button
	Dim btnSum As Button
	
	Dim lblTitle As Label
	Dim PanelBottom As Panel
	
	Dim dtID As Int
	Dim strLine1 As String
	Dim strLine2 As String
	
	Dim pnl As Panel
	Dim chk As CheckBox
	
	'SYSTEM SETTING
	Dim strCurrencySymbol As String
	
	'EXPORT EXCEL
	Dim table1 As Table
	Dim InvoiceList As List
	Dim CurrencySimbol As String
	
	Private btnShare As Button
	Private clv1 As CustomListView
	Private lblLine1 As Label
	Private lblLine2 As Label
End Sub

Sub Activity_Create(FirstTime As Boolean)
	'Do not forget to load the layout file created with the visual designer. For example:
	Activity.LoadLayout("lyDailyReport")
	shared = rp.GetSafeDirDefaultExternal("")
	kvs.Initialize(shared, "Userdatastore")
	If SQL1.IsInitialized = False Then
		SQL1.Initialize(shared, "kledb.db", False)
	End If
	
	
	cboTTDateFrom.Initialize("cboTTDateFrom")
	cboTTDateTo.Initialize("cboTTDateTo")
	PanelCenter.AddView (cboTTDateFrom,90dip   ,btnSearch.top  ,150dip,40dip)
	PanelCenter.AddView (cboTTDateTo,90dip   ,btnSearch.Top + 40dip  ,150dip,40dip)
	
	'PanelCenter.AddView (cboTTDateTo,0,80,100%x-20dip,50dip)
	cboTTDateFrom.DateAsLong = DateTime.Now
	cboTTDateTo.DateAsLong = DateTime.Now
	
	'GET SYSTEM
	strCurrencySymbol = kvs.Get ("strCurrencySymbol")
	
	'clv1.Initialize(Me, "clv1")
	'Activity.AddView(clv1.AsView, 0, lblTitle.Height + PanelCenter.Height  , 100%x, 100%y -  lblTitle.Height - PanelBottom.Height - PanelCenter.Height  )

	
	CurrencySimbol = kvs.Get("CurrencySimbol")
		
	If FirstTime = True Then
		RefreshGrid
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
	Dim strDate As String
	Dim strTime As String
	Dim strSum As Double
	
	cursor1 = SQL1.ExecQuery("SELECT * FROM TTMaster WHERE TTDateInt >= " & (cboTTDateFrom.DateAsLong /1000) & " AND TTDateInt <= " & (cboTTDateTo.DateAsLong /1000) & " AND Status = 1 ORDER BY TTDate")
	For i = 0 To cursor1.RowCount - 1
		cursor1.Position = i
		strDate  = DateTime.GetDayOfMonth((cursor1.GetString("TTDate"))) & "/" & DateTime.GetMonth((cursor1.GetString("TTDate"))) & "/" & DateTime.GetYear((cursor1.GetString("TTDate")))
		DateTime.TimeFormat = "KK:mm:ss a"
		strTime = DateTime.Time(cursor1.GetString("TTTime"))
		dtID = cursor1.getString("ID")
		strLine1 = cursor1.getString("CustomerName")
		strLine2 = cursor1.getString("MasterCode") & " | " & CurrencySimbol & " " & NumberFormat2(cursor1.getString("TotalAmtIncGST"),0,2,2,False)
		strLine2 = strLine2 & " | " &  strDate & " " & strTime
		clv1.Add(CreateListItem(strLine1,strLine2,clv1.AsView.Width, 60dip), dtID)
		strSum = strSum + cursor1.GetString("TotalAmtIncGST")
	Next
	
	btnSum.Text = "Total: " & CurrencySimbol & NumberFormat2(strSum,1,2,2,False)
	ProgressDialogHide
	
End Sub


Sub CreateListItem( Line1 As String, Line2 As String, Width As Int, Height As Int) As Panel
	
	
	'lyDailyReportDetail
	Dim p As Panel
	p.Initialize("")
	'we need to add the panel to a parent to set its dimensions. It will be removed after the layout is loaded.
	Activity.AddView(p, 0, 0, Width, Height)
	p.LoadLayout("lyDailyReportDetail")
	p.RemoveView
	'label1 and button1 will point to the last added views.
	lblLine1.Text =Line1
	lblLine2.Text =Line2
	
	Return p
	
	
End Sub

Sub btnExport_Click
	
	
	Dim CSVList As List
	CSVList.Initialize
   
	'cursor1.Position = 0
	Dim ReportTitle As String
	ReportTitle = "Date,Time,DocNo,Customer,TotalAmt,DiscountAmt,GSTAmt,CreatedBy,TaxAmount,ZeroTaxAmount"
	CSVList.Add(ReportTitle)
	Dim NewRecord As String
	Dim strDate As String
	Dim strTime As String
	For i = 0 To cursor1.RowCount -1
		cursor1.Position = i
		strDate  = DateTime.GetDayOfMonth((cursor1.GetString("TTDate"))) & "/" & DateTime.GetMonth((cursor1.GetString("TTDate"))) & "/" & DateTime.GetYear((cursor1.GetString("TTDate")))
		DateTime.TimeFormat = "KK:mm:ss a"
		strTime = DateTime.Time(cursor1.GetString("TTTime"))
		NewRecord =  strDate & "," & strTime & "," & cursor1.GetString("MasterCode") & "," & cursor1.GetString("CustomerName")  & ","
		NewRecord = NewRecord & cursor1.GetString("TotalAmtIncGST") & "," & cursor1.GetString("DiscountAmt") & "," & cursor1.GetString("GSTAmt") & ","
		NewRecord = NewRecord & cursor1.GetString("CreatedBy") & "," & cursor1.GetString("T6Amount")  & "," & cursor1.GetString("T0Amount")
		
		CSVList.Add(NewRecord)
		' cursor1.NextRecord
	Next
   
	File.WriteList(shared, "dailyreport.csv", CSVList)
	Msgbox("Export Successfully","EXPORT")
	
	Dim FileName As String = "dailyreport.csv"
	File.Copy(shared, FileName, Starter.Provider.SharedFolder, FileName)
	Dim in As Intent
	in.Initialize(in.ACTION_VIEW, "")
	Starter.Provider.SetFileUriAsIntentData(in, FileName)
	'Type must be set after calling SetFileUriAsIntentData
	in.SetType("text/csv")
	'in.SetType("text/plain")
	StartActivity(in)
   
	'  	Dim inttFile As Intent
	'    inttFile.Initialize(inttFile.ACTION_VIEW ,"file://" & File.Combine(shared,"dailyreport.csv"))
	'    inttFile.SetType("application/vnd.ms-excel")
	'    StartActivity(inttFile)
	
End Sub

Sub btnBack_Click
	StartActivity("MenuReport")
	Activity.Finish
	
End Sub

Sub btnShare_Click
	
	Dim CSVList As List
	CSVList.Initialize
   
	'cursor1.Position = 0
	Dim ReportTitle As String
	ReportTitle = "Date,Time,DocNo,Customer,TotalAmt,DiscountAmt,GSTAmt,CreatedBy,TaxAmount,ZeroTaxAmount"
	CSVList.Add(ReportTitle)
	Dim NewRecord As String
	Dim strDate As String
	Dim strTime As String
	For i = 0 To cursor1.RowCount -1
		cursor1.Position = i
		strDate  = DateTime.GetDayOfMonth((cursor1.GetString("TTDate"))) & "/" & DateTime.GetMonth((cursor1.GetString("TTDate"))) & "/" & DateTime.GetYear((cursor1.GetString("TTDate")))
		DateTime.TimeFormat = "KK:mm:ss a"
		strTime = DateTime.Time(cursor1.GetString("TTTime"))
		NewRecord =  strDate & "," & strTime & "," & cursor1.GetString("MasterCode") & "," & cursor1.GetString("CustomerName")  & ","
		NewRecord = NewRecord & cursor1.GetString("TotalAmtIncGST") & "," & cursor1.GetString("DiscountAmt") & "," & cursor1.GetString("GSTAmt") & ","
		NewRecord = NewRecord & cursor1.GetString("CreatedBy") & "," & cursor1.GetString("T6Amount")  & "," & cursor1.GetString("T0Amount")
		
		CSVList.Add(NewRecord)
		' cursor1.NextRecord
	Next
   
	File.WriteList(shared, "dailyreport.csv", CSVList)
	Msgbox("Please Share The File Through Office APP","Share")
	Dim FileName As String = "dailyreport.csv"
	File.Copy(shared, FileName, Starter.Provider.SharedFolder, FileName)
	Dim in As Intent
	in.Initialize(in.ACTION_VIEW, "")
	Starter.Provider.SetFileUriAsIntentData(in, FileName)
	'Type must be set after calling SetFileUriAsIntentData
	in.SetType("text/csv")
	'in.SetType("text/plain")
	StartActivity(in)
   
	
	
End Sub