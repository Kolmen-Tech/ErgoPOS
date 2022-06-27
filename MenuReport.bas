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
End Sub

Sub Globals
	'These global variables will be redeclared each time the activity is created.
	'These variables can only be accessed from this module.
	Private kvs As KeyValueStore	
	Dim PanelTopMenu As Panel
	Dim PanelBottom As Panel	
	Private btnBack As Button
	Private clv1 As CustomListView	
	Dim Bitmap1 As Bitmap
	Dim Bitmap2 As Bitmap
	Dim Bitmap3 As Bitmap
	Dim Bitmap4 As Bitmap
	Dim Bitmap5 As Bitmap
	Dim Bitmap6 As Bitmap
	Dim Bitmap7 As Bitmap
	Private lblLine1 As Label
	Private imgIcon As ImageView
	
	
End Sub

Sub Activity_Create(FirstTime As Boolean)
	'Do not forget to load the layout file created with the visual designer. For example:
	Activity.LoadLayout("lyMenuReports")
	shared = rp.GetSafeDirDefaultExternal("")
	kvs.Initialize(shared, "Userdatastore")
	
	Bitmap1.Initialize(File.DirAssets,"report1.png")
	Bitmap2.Initialize(File.DirAssets,"report1.png")
	Bitmap3.Initialize(File.DirAssets,"customer.png")
	Bitmap4.Initialize(File.DirAssets,"items.png")
	Bitmap5.Initialize(File.DirAssets,"setting.png")
	Bitmap6.Initialize(File.DirAssets,"Home.png")
	Bitmap7.Initialize(File.DirAssets,"report.png")

End Sub

Sub Activity_Resume
	RefreshGrid
End Sub

Sub Activity_Pause (UserClosed As Boolean)

End Sub


Sub btnBack_Click
	Activity.Finish
End Sub

Sub RefreshGrid
	clv1.Clear
	clv1.Add(CreateListItem(1,"Daily Sales Report","View, Export Daily Sales Report",clv1.AsView.Width, 60dip), 1)
	clv1.Add(CreateListItem(1,"Daily Sales Report (Item)","View, Export Daily Sales Report (Itemize)",clv1.AsView.Width, 60dip),  2)
	clv1.Add(CreateListItem(1,"Tax Summary Report","View, Export Tax Summary Report",clv1.AsView.Width, 60dip), 3)
	
	If moPublic.SuperBossMode = True Then
		clv1.Add(CreateListItem(1,"Daily Profit Report","View, Export Daily Profit Report",clv1.AsView.Width, 60dip),  4)
	End If
End Sub

Sub clv1_ItemClick (Index As Int, Value As Object)

	Dim strValue As String
	strValue = Value
	
	Select strValue
		Case "1" 'New Invoice
			StartActivity("DailyReport")
		Case "2" 'Invoice List
			StartActivity("DailyReportItem")
		Case "3" 'Customer'
			StartActivity("GSTReport")
		Case "4" 'Daily Profit Report
			StartActivity("DailyProfitReport")
		Case "5" 'Setting'
			StartActivity("SystemSetting")
		Case "6" 'My Company'
			StartActivity("MyCompany")
		Case "7" 'Reports
			StartActivity("Reports")
	End Select
End Sub


Sub CreateListItem(intIcon As Int, Line1 As String, Line2 As String, Width As Int, Height As Int) As Panel
	
	Dim p As Panel
	p.Initialize("")
	'we need to add the panel to a parent to set its dimensions. It will be removed after the layout is loaded.
	Activity.AddView(p, 0, 0, Width, Height)
	p.LoadLayout("lyMenueReportDetail")
	p.RemoveView
	'label1 and button1 will point to the last added views.
	lblLine1.Text = Line1
	
	Select intIcon
		Case 1
			imgIcon.Bitmap = Bitmap1
		Case 2
			imgIcon.Bitmap = Bitmap2
		Case 3
			imgIcon.Bitmap = Bitmap3
		Case 4
			imgIcon.Bitmap = Bitmap4
		Case 5
			imgIcon.Bitmap = Bitmap5
		Case 6
			imgIcon.Bitmap = Bitmap6
		Case 7
			imgIcon.Bitmap = Bitmap7
	End Select
	
	
	Return p
	
	
'	Dim p As Panel
'	p.Initialize("")
'	p.Color = Colors.White  
'	
	'
'	
'	'图像
'	Dim ImgIcon As ImageView 
'	ImgIcon.Initialize ("ImgIcon")
'	
'	Select intIcon
'		Case 1
'			ImgIcon.Bitmap = Bitmap1
'		Case 2
'			ImgIcon.Bitmap = Bitmap2
'		Case 3
'			ImgIcon.Bitmap = Bitmap3
'		Case 4
'			ImgIcon.Bitmap = Bitmap4
'		Case 5
'			ImgIcon.Bitmap = Bitmap5
'		Case 6
'			ImgIcon.Bitmap = Bitmap6
'		Case 7
'			ImgIcon.Bitmap = Bitmap7
'	End Select
'			
'	Dim lblLine1 As Label 
'	lblLine1.Initialize("")
'	lblLine1.Text = Line1
'	lblLine1.Textsize = 19
'	lblLine1.TextColor = Colors.RGB (37,160,255)
	'
'	Dim lblLine2 As Label 
'	lblLine2.Initialize("")
'	lblLine2.Text = Line2
'	lblLine2.Textsize = 14
'	lblLine2.TextColor = Colors.Gray 
'	
'	p.AddView(ImgIcon,15dip,10dip,50dip,50dip)
'	p.AddView (lblLine1, 85dip, 10dip, 100%x - 75dip,25dip)
'	p.AddView (lblLine2, 85dip, 40dip , 100%x - 85dip ,20dip)
	'
'	Return p
	
End Sub