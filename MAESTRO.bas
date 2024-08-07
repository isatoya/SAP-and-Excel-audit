Attribute VB_Name = "MAESTRO"
Option Explicit
'variables para todo el proyecto

    Dim Fecha1, Fecha2, Fecha3, mes, Mes_texto, A�o, mes_eliminar, dia As String
    Dim ruta, Ruta_A�o, Ruta_Mes, Ruta_Audi As String
    Dim CelsAG As Object
    
    Sub Ejecutar_MAESTRO()

    ' Verificar si hay datos en las celdas I8 y M8
    If ThisWorkbook.Sheets("Reportes").Range("I8").Value = "" Or ThisWorkbook.Sheets("Reportes").Range("M8").Value = "" Then
        MsgBox "Datos incompletos, por favor ingrese los datos antes de ejecutar.", vbExclamation
        Exit Sub
    End If

    ' Llama a cada una de las funciones
    CrearCarpetas
    CreacionMaestro
    
    MsgBox "Reporte finalizado. Lo podra encontrar en la carpeta correspondiente.", vbInformation

End Sub

Sub InicializarVariables()
'Definicion de las variables
    
    'Fechas
    mes = ThisWorkbook.Sheets("Reportes").Range("N8").Text
    Mes_texto = ThisWorkbook.Sheets("Reportes").Range("I12").Value
    A�o = ThisWorkbook.Sheets("Reportes").Range("I10").Value
    Fecha1 = ThisWorkbook.Sheets("Reportes").Range("I8").Value
    Fecha2 = ThisWorkbook.Sheets("Reportes").Range("M8").Value
    dia = ThisWorkbook.Sheets("Reportes").Range("N10").Text
    
    'Rutas
    ruta = ThisWorkbook.Path & "\"
    'ruta = ThisWorkbook.Sheets("Reportes").Range("D30").Text
    Ruta_A�o = ruta & A�o
    Ruta_Mes = Ruta_A�o & "\" & mes & ". " & Mes_texto
    'ORIGINAL: G:\H2R\ABS\PAYROLL\Nominas\
    

End Sub
Sub CrearCarpetas()
    
    'Creaci�n y validacion de las carpetas
    InicializarVariables
    '''''''
    ''A�O''
    '''''''
    Ruta_A�o = ruta & A�o
    If Dir(Ruta_A�o, vbDirectory + vbHidden) = "" Then
        'Comprueba que la carpeta no exista para crear el directorio.
        If Dir(Ruta_A�o & vbDirectory + vbHidden) = "" Then MkDir Ruta_A�o
    End If
    '''''''
    ''MES''
    '''''''
    Ruta_Mes = Ruta_A�o & "\" & mes & ". " & Mes_texto
    If Dir(Ruta_Mes, vbDirectory + vbHidden) = "" Then
        'Comprueba que la carpeta no exista para crear el directorio.
        If Dir(Ruta_Mes & vbDirectory + vbHidden) = "" Then MkDir Ruta_Mes
    End If
        
End Sub
Sub Descarga_zhr929()

 '-------------------- DESCARGA SEGUNDO REPORTE : ZHR929 --------------------
    InicializarVariables
    If ThisWorkbook.Sheets("Reportes").Range("I8").Value = "" Or ThisWorkbook.Sheets("Reportes").Range("M8").Value = "" Then
        MsgBox "Datos incompletos, por favor ingrese los datos antes de ejecutar.", vbExclamation
        Exit Sub
    End If
    
     ' Conexion con SAP
    Dim SapGuiAuto As Object
    Dim App As Object
    Dim Connection As Object
    Dim session As Object

    Application.DisplayAlerts = False
    Set SapGuiAuto = GetObject("SAPGUI")
    Set App = SapGuiAuto.GetScriptingEngine
    Set Connection = App.Children(0)
    Set session = Connection.Children(0)
    
    'Entra a la transacion SQ01
    session.findById("wnd[0]/tbar[0]/okcd").Text = "/nZHR929"
    session.findById("wnd[0]").sendVKey 0
    
    'Busca variante
    session.findById("wnd[0]/tbar[1]/btn[17]").press
    session.findById("wnd[1]/usr/txtV-LOW").Text = "TC_NOMINA"
    session.findById("wnd[1]/usr/txtENAME-LOW").Text = "ASANC1K"
    session.findById("wnd[1]/usr/txtV-LOW").caretPosition = 9
    session.findById("wnd[1]/tbar[0]/btn[8]").press
    
    'Fechas
    session.findById("wnd[0]/usr/ctxtPNPBEGDA").Text = Fecha1
    session.findById("wnd[0]/usr/ctxtPNPENDDA").Text = Fecha2
    session.findById("wnd[0]/usr/ctxtPNPENDDA").SetFocus
    session.findById("wnd[0]/usr/ctxtPNPENDDA").caretPosition = 8
    session.findById("wnd[0]").sendVKey 0
    
    'Ejecutar
    session.findById("wnd[0]/tbar[1]/btn[8]").press

    'Descargar
    session.findById("wnd[0]/mbar/menu[0]/menu[3]/menu[1]").Select
    session.findById("wnd[1]/usr/ctxtDY_PATH").Text = Ruta_Mes
    session.findById("wnd[1]/usr/ctxtDY_FILENAME").Text = "ZHR929.XLSX"
    session.findById("wnd[1]/usr/ctxtDY_FILENAME").caretPosition = 13
    session.findById("wnd[1]/tbar[0]/btn[11]").press
    session.findById("wnd[0]/usr/cntlGRID1/shellcont/shell").setRowSize 1, 96
    session.findById("wnd[0]/usr/cntlGRID1/shellcont/shell").setRowSize 2, -1
        
    'Mensaje
    MsgBox "Por favor guarde y luego cierre el reporte de la ZHR929 recien descargado de SAP. Recuerde el lugar en donde lo guardo.", vbInformation


End Sub
Sub Descarga_maestro()
    
    InicializarVariables
    CrearCarpetas
'-------------------- DESCARGA PRIMER REPORTE : ALTAS Y BAJAS --------------------
    If ThisWorkbook.Sheets("Reportes").Range("I8").Value = "" Or ThisWorkbook.Sheets("Reportes").Range("M8").Value = "" Then
        MsgBox "Datos incompletos, por favor ingrese los datos antes de ejecutar.", vbExclamation
        Exit Sub
    End If
    
    ' Conexion con SAP
    Dim SapGuiAuto As Object
    Dim App As Object
    Dim Connection As Object
    Dim session As Object

    Application.DisplayAlerts = False
    Set SapGuiAuto = GetObject("SAPGUI")
    Set App = SapGuiAuto.GetScriptingEngine
    Set Connection = App.Children(0)
    Set session = Connection.Children(0)
    
    'Vuelve a la pantalla inicial
    session.findById("wnd[0]/tbar[0]/okcd").Text = "/n"
    session.findById("wnd[0]").sendVKey 0
    
    'Entra a la transacion SQ01
    session.findById("wnd[0]/tbar[0]/okcd").Text = "/nSQ01"
    session.findById("wnd[0]").sendVKey 0
    
    'Busca el grupo
    session.findById("wnd[0]/tbar[1]/btn[19]").press
    session.findById("wnd[1]/usr/cntlGRID1/shellcont/shell").currentCellRow = -1
    session.findById("wnd[1]/usr/cntlGRID1/shellcont/shell").selectColumn "DBGBNUM"
    session.findById("wnd[1]/tbar[0]/btn[29]").press
    session.findById("wnd[2]/usr/ssub%_SUBSCREEN_FREESEL:SAPLSSEL:1105/ctxt%%DYN001-LOW").Text = "/SAPQUERY/H6"
    session.findById("wnd[2]/tbar[0]/btn[0]").press
    session.findById("wnd[1]/usr/cntlGRID1/shellcont/shell").selectedRows = "0"
    session.findById("wnd[1]/tbar[0]/btn[0]").press
    
    'Ingresa el query Z_MAESTRO_NOM
    session.findById("wnd[0]/usr/ctxtRS38R-QNUM").Text = "Z_MAESTRO_CRES"
    session.findById("wnd[0]").sendVKey 0
    session.findById("wnd[0]/tbar[1]/btn[8]").press
    
    'Cambia fechas
    
    Fecha1 = ThisWorkbook.Sheets("Reportes").Range("I8").Value
    Fecha3 = "01" & ThisWorkbook.Sheets("Reportes").Range("D31").Text & _
             ThisWorkbook.Sheets("Reportes").Range("E31").Value
    
    session.findById("wnd[0]/usr/ctxtPNPBEGDA").Text = Fecha1
    session.findById("wnd[0]/usr/ctxtPNPENDDA").Text = Fecha3
    session.findById("wnd[0]/usr/ctxtPNPBEGPS").Text = Fecha1
    session.findById("wnd[0]/usr/ctxtPNPENDPS").Text = Fecha3
    session.findById("wnd[0]/usr/ctxtPNPENDPS").SetFocus
    session.findById("wnd[0]").sendVKey 0
    session.findById("wnd[0]/usr/ctxtSP$00004-LOW").Text = Fecha1
    session.findById("wnd[0]/usr/ctxtSP$00004-HIGH").Text = Fecha3
    session.findById("wnd[0]/usr/ctxtSP$00004-HIGH").SetFocus
    
    'Ejecuta
    session.findById("wnd[0]/tbar[1]/btn[8]").press
    
    'Exportar
    session.findById("wnd[0]/mbar/menu[0]/menu[4]/menu[2]").Select
    session.findById("wnd[1]/usr/subSUBSCREEN_STEPLOOP:SAPLSPO5:0150/sub:SAPLSPO5:0150/radSPOPLI-SELFLAG[1,0]").Select
    session.findById("wnd[1]/usr/subSUBSCREEN_STEPLOOP:SAPLSPO5:0150/sub:SAPLSPO5:0150/radSPOPLI-SELFLAG[1,0]").SetFocus
    session.findById("wnd[1]/tbar[0]/btn[0]").press
    session.findById("wnd[1]/usr/ctxtDY_PATH").Text = Ruta_Mes
    session.findById("wnd[1]/usr/ctxtDY_FILENAME").Text = "BAJAS_ALTAS.XLS"
    session.findById("wnd[1]/usr/ctxtDY_FILENAME").caretPosition = 15
    session.findById("wnd[1]/tbar[0]/btn[11]").press
    
    'Vuelve a la pantalla inicial
    session.findById("wnd[0]/tbar[0]/okcd").Text = "/n"
    session.findById("wnd[0]").sendVKey 0
    
    'Organizar documento
    Application.CutCopyMode = False
    Workbooks.Open Ruta_Mes & "\" & "BAJAS_ALTAS.XLS"
    ActiveSheet.Cells.Select
    Selection.Copy
    Workbooks.Add
    ActiveSheet.Paste
    ActiveWorkbook.SaveAs Ruta_Mes & "\" & "BAJAS_ALTAS.XLSX"
    ActiveWorkbook.Close SaveChanges:=True
    Workbooks("BAJAS_ALTAS.XLS").Close
    Kill Ruta_Mes & "\" & "BAJAS_ALTAS.XLS"
    
    'Cambios de formato
    Workbooks.Open Ruta_Mes & "\" & "BAJAS_ALTAS.XLSX"
    Workbooks("BAJAS_ALTAS.XLSX").Activate
    Rows("1:4").Delete
    Rows("2").Delete
    Columns("A").Delete
    Columns("A:AB").AutoFit
    Workbooks("BAJAS_ALTAS.XLSX").Save
    Workbooks("BAJAS_ALTAS.XLSX").Close

    
 '-------------------- DESCARGA SEGUNDO REPORTE : MAESTRO --------------------
    
    'Entra a la transacion SQ01
    session.findById("wnd[0]/tbar[0]/okcd").Text = "/nSQ01"
    session.findById("wnd[0]").sendVKey 0
    
    'Busca el grupo
    session.findById("wnd[0]/tbar[1]/btn[19]").press
    session.findById("wnd[1]/usr/cntlGRID1/shellcont/shell").currentCellRow = -1
    session.findById("wnd[1]/usr/cntlGRID1/shellcont/shell").selectColumn "DBGBNUM"
    session.findById("wnd[1]/tbar[0]/btn[29]").press
    session.findById("wnd[2]/usr/ssub%_SUBSCREEN_FREESEL:SAPLSSEL:1105/ctxt%%DYN001-LOW").Text = "/SAPQUERY/H6"
    session.findById("wnd[2]/tbar[0]/btn[0]").press
    session.findById("wnd[1]/usr/cntlGRID1/shellcont/shell").selectedRows = "0"
    session.findById("wnd[1]/tbar[0]/btn[0]").press
    
    'Ingresa el query Z_MAESTRO_NOM
    session.findById("wnd[0]/usr/ctxtRS38R-QNUM").Text = "Z_MAESTRO_NOMA"
    session.findById("wnd[0]").sendVKey 0
    session.findById("wnd[0]/tbar[1]/btn[8]").press
    
    'Cambia fechas
    session.findById("wnd[0]/usr/ctxtPNPBEGDA").Text = Fecha1
    session.findById("wnd[0]/usr/ctxtPNPENDDA").Text = Fecha2
    session.findById("wnd[0]/usr/ctxtPNPBEGPS").Text = Fecha1
    session.findById("wnd[0]/usr/ctxtPNPENDPS").Text = Fecha2
    session.findById("wnd[0]/usr/ctxtPNPENDPS").SetFocus
    
    'Ejecuta
    session.findById("wnd[0]/tbar[1]/btn[8]").press
    
    'Descargar
    session.findById("wnd[0]/tbar[1]/btn[8]").press
    session.findById("wnd[1]/tbar[0]/btn[0]").press
    session.findById("wnd[1]/tbar[0]/btn[0]").press
    
    MsgBox "Por favor guarde y luego cierre el reporte recien descargado de SAP. Recuerde el lugar en donde lo guardo.", vbInformation

End Sub

Sub CreacionMaestro()
    
    InicializarVariables
    Dim ruta_maestroA As String
    Dim MAESTRO As Workbook

'----------------------------------- Solicitar al usuario que abra un archivo -----------------------------------
'Solciita al usuario abrir el primer documento descargado de sap en la transaccion SQ01 con la variante Z_MAESTRO_NOMA

    MsgBox "Por favor selecciene el archivo previamente guardado (el maestro de la variante Z_MAESTRO_NOMA).", vbInformation
    ruta_maestroA = Application.GetOpenFilename("Archivos Excel (*.xls; *.xlsx), *.xls; *.xlsx")
    Application.AskToUpdateLinks = False
    
    ' Abre el reporte seleccionado por el usuario y copia la primera hoja
If ruta_maestroA <> "Falso" Then
        
        Set MAESTRO = Workbooks.Open(Filename:=ruta_maestroA, UpdateLinks:=0)
        MAESTRO.Activate
        Worksheets("Hoja1").Activate
        Columns("A:AT").Select
        Selection.Copy
        
        'Crea el archivo nuevo
        Workbooks.Add
        ActiveSheet.Range("A1").PasteSpecial Paste:=xlPasteAll
        Columns("A:AT").AutoFit
        Application.CutCopyMode = False
    
        ' Verifica si el archivo ya existe en la ruta y lo elimina
        If Dir(Ruta_Mes & "\" & A�o & mes & " MAESTRO ACTIVOS" & ".xlsx") <> "" Then
            Kill Ruta_Mes & "\" & A�o & mes & " MAESTRO ACTIVOS" & ".xlsx"
End If
        
'----------------------------------- Empieza a trabajar con el archivo nuevo del maestro -----------------------------------
    
    'Crea el archivo nuevo
    ActiveSheet.Name = "ORIGINAL"
    ActiveWorkbook.SaveAs Ruta_Mes & "\" & A�o & mes & " MAESTRO ACTIVOS" & ".xlsx"
    MAESTRO.Save
    MAESTRO.Close
    Application.AskToUpdateLinks = True
    
    'Crea las hojas
    Workbooks(A�o & mes & " MAESTRO ACTIVOS" & ".xlsx").Activate
    Sheets.Add(After:=Sheets(Sheets.Count)).Name = "SALARIAL"
    Sheets.Add(After:=Sheets(Sheets.Count)).Name = "NETO APROXIMADO"
    Sheets.Add(After:=Sheets(Sheets.Count)).Name = "EXCLUSIONES"
    Sheets.Add(After:=Sheets(Sheets.Count)).Name = "ALTAS"
    Sheets.Add(After:=Sheets(Sheets.Count)).Name = "BAJAS"
    Sheets.Add(After:=Sheets(Sheets.Count)).Name = "ZHR929"
    Sheets.Add(After:=Sheets(Sheets.Count)).Name = "NO SALARIAL"
    Sheets.Add(After:=Sheets(Sheets.Count)).Name = "MAESTRO MES ANTERIOR"

    
    'Filtra para crear la hoja salarial
    Sheets("ORIGINAL").Activate
    Rows("1:1").AutoFilter
    Rows("1:1").AutoFilter Field:=8, Criteria1:="<>Externos"
    Range("1:1").AutoFilter Field:=35, Criteria1:="<>*PAGO IND*"
    Sheets("ORIGINAL").Select
    ActiveSheet.UsedRange.SpecialCells(xlCellTypeVisible).Copy
    Sheets("SALARIAL").Select
    ActiveSheet.Cells(1, 1).PasteSpecial Paste:=xlPasteAll
    
    'Filtra para crear la hoja no salarial
    Sheets("ORIGINAL").Activate
    ActiveSheet.ShowAllData
    Rows("1:1").AutoFilter
    Rows("1:1").AutoFilter Field:=8, Criteria1:="<>Externos"
    Range("1:1").AutoFilter Field:=35, Criteria1:="=*PAGO IND*"
    Sheets("ORIGINAL").Select
    ActiveSheet.UsedRange.SpecialCells(xlCellTypeVisible).Copy
    Sheets("NO SALARIAL").Select
    ActiveSheet.Cells(1, 1).PasteSpecial Paste:=xlPasteAll
    
'----------------------------------- CREA HOJA DE ALTAS -----------------------------------
    
    'Abre el archivo descargado de sap, filtra copia y pega
    Workbooks.Open Ruta_Mes & "\" & "BAJAS_ALTAS.XLSX"
    Workbooks("BAJAS_ALTAS.XLSX").Activate
    Rows("1:1").AutoFilter
    Rows("1:1").AutoFilter Field:=5, Criteria1:="=Contrataci�n"
    Columns("A:AB").Select
    Selection.SpecialCells(xlCellTypeVisible).Copy
    Workbooks(A�o & mes & " MAESTRO ACTIVOS" & ".xlsx").Activate
    Sheets("ALTAS").Activate
    ActiveSheet.Range("A1").PasteSpecial Paste:=xlPasteAll
    Application.CutCopyMode = False
    
    'Formato de la primera linea
    With Range("A1:AB1")
        .Interior.Color = RGB(213, 219, 219)
        .Font.Bold = True
        .HorizontalAlignment = xlCenter
    End With
    Columns("A:AC").AutoFit
     
    'Eliminar filas que sean del mes siguiente
    Dim lastRow_A As Long
    lastRow_A = ActiveSheet.Cells(ActiveSheet.Rows.Count, "A").End(xlUp).row
    Columns("D:D").Select
    Selection.Insert Shift:=xlToLeft, CopyOrigin:=xlFormatFromLeftOrAbove
    
    If lastRow_A >= 2 Then
        Range("D2:D" & lastRow_A).Formula = "=MID(RC[-1],4,2)"
    End If
    
    Columns("D:D").Select
    Selection.Copy
    Selection.PasteSpecial Paste:=xlPasteValues, Operation:=xlNone, SkipBlanks _
        :=False, Transpose:=False
        
    Dim i As Long
    lastRow_A = ActiveSheet.Cells(ActiveSheet.Rows.Count, "A").End(xlUp).row
    mes_eliminar = ThisWorkbook.Sheets("Reportes").Range("D31").Text
    For i = lastRow_A To 1 Step -1
        If Cells(i, "D").Value = mes_eliminar Then
            Rows(i).Delete
        End If
    Next i
    Columns("D:D").Select
    Selection.Delete
    
    'Convierte fechas de contab. de 01.01.9999 a 01/01/9999
    Sheets("ALTAS").Activate
    Dim CelsC As Range
    Dim UltimaFilaC As Long
    UltimaFilaC = ActiveSheet.Cells(Rows.Count, 1).End(xlUp).row
    

    If UltimaFilaC >= 2 Then
        For Each CelsC In ActiveSheet.Range("C2:C" & UltimaFilaC)
            If Len(CelsC.Value) = 10 And Mid(CelsC.Value, 3, 1) = "." And Mid(CelsC.Value, 6, 1) = "." Then
                CelsC.Value = DateSerial(Right(CelsC.Value, 4), Mid(CelsC.Value, 4, 2), Left(CelsC.Value, 2))
                CelsC.NumberFormat = "dd/mm/yyyy"
            End If
        Next CelsC
    End If
    
    If UltimaFilaC >= 2 Then
        For Each CelsC In ActiveSheet.Range("AB2:AB" & UltimaFilaC)
            If Len(CelsC.Value) = 10 And Mid(CelsC.Value, 3, 1) = "." And Mid(CelsC.Value, 6, 1) = "." Then
                CelsC.Value = DateSerial(Right(CelsC.Value, 4), Mid(CelsC.Value, 4, 2), Left(CelsC.Value, 2))
                CelsC.NumberFormat = "dd/mm/yyyy"
            End If
        Next CelsC
    End If
    
    'Separa a los del grupo de personal que sean externos
    Dim x As Long
    lastRow_A = ActiveSheet.Cells(ActiveSheet.Rows.Count, "A").End(xlUp).row
    For x = 1 To lastRow_A
        If Cells(x, "T").Value = "Externos" Then
            Rows(x).Resize(2).Insert Shift:=xlDown
            Exit For
        End If
    Next x
    
    'Hace el ContarA
    lastRow_A = ActiveSheet.Cells(1, "A").End(xlDown).row + 1
    Range("B" & lastRow_A).Formula = "=COUNTA(C2:C" & lastRow_A - 1 & ")"
    With Range("B" & lastRow_A)
        .Interior.Color = RGB(255, 255, 0)
        .Font.Bold = True
        .HorizontalAlignment = xlCenter
    End With
    ActiveWorkbook.Save
    
        
'----------------------------------- CREA HOJA DE BAJAS -----------------------------------

    'Filtra el archivo descargado de sap, filtra, copia y pega
    Workbooks("BAJAS_ALTAS.XLSX").Activate
    ActiveSheet.ShowAllData
    Rows("1:1").AutoFilter
    Rows("1:1").AutoFilter Field:=5, Criteria1:="=Desvinculacion de Personal"
    Columns("A:AB").Select
    Selection.SpecialCells(xlCellTypeVisible).Copy
    Workbooks(A�o & mes & " MAESTRO ACTIVOS" & ".xlsx").Activate
    Sheets("BAJAS").Activate
    ActiveSheet.Range("A1").PasteSpecial Paste:=xlPasteAll
    Application.CutCopyMode = False
    
    'Cambia fechas de el mes anterior a las ultimas del presente
    lastRow_A = ActiveSheet.Cells(ActiveSheet.Rows.Count, "A").End(xlUp).row
    Columns("D:D").Select
    Selection.Insert Shift:=xlToLeft, CopyOrigin:=xlFormatFromLeftOrAbove
    If lastRow_A >= 2 Then
        Range("D2:D" & lastRow_A).Formula = "=MID(RC[-1],4,2)"
    End If
    
    Columns("D:D").Select
    Selection.Copy
    Selection.PasteSpecial Paste:=xlPasteValues, Operation:=xlNone, SkipBlanks _
        :=False, Transpose:=False
        
    Dim y As Long
    lastRow_A = ActiveSheet.Cells(ActiveSheet.Rows.Count, "A").End(xlUp).row
    For y = 2 To lastRow_A
        If ActiveSheet.Cells(y, "D").Value = mes_eliminar Then
            ActiveSheet.Cells(y, "C").Value = dia & "." & mes & "." & A�o
        End If
    Next y
    Columns("D:D").Select
    Selection.Delete
    
    'Convierte fechas de contab. de 01.01.9999 a 01/01/9999
    Sheets("BAJAS").Activate
    UltimaFilaC = ActiveSheet.Cells(Rows.Count, 1).End(xlUp).row
    
    If UltimaFilaC >= 2 Then
        For Each CelsC In ActiveSheet.Range("C2:C" & UltimaFilaC)
            If Len(CelsC.Value) = 10 And Mid(CelsC.Value, 3, 1) = "." And Mid(CelsC.Value, 6, 1) = "." Then
                CelsC.Value = DateSerial(Right(CelsC.Value, 4), Mid(CelsC.Value, 4, 2), Left(CelsC.Value, 2))
                CelsC.NumberFormat = "dd/mm/yyyy"
            End If
        Next CelsC
    End If
    
    If UltimaFilaC >= 2 Then
        For Each CelsC In ActiveSheet.Range("AB2:AB" & UltimaFilaC)
            If Len(CelsC.Value) = 10 And Mid(CelsC.Value, 3, 1) = "." And Mid(CelsC.Value, 6, 1) = "." Then
                CelsC.Value = DateSerial(Right(CelsC.Value, 4), Mid(CelsC.Value, 4, 2), Left(CelsC.Value, 2))
                CelsC.NumberFormat = "dd/mm/yyyy"
            End If
        Next CelsC
    End If
    
    'Formato de la primera fila
    With Range("A1:AB1")
        .Interior.Color = RGB(213, 219, 219)
        .Font.Bold = True
        .HorizontalAlignment = xlCenter
    End With
    Columns("A:AC").AutoFit
    
    'Guarda y cierra
    ActiveWorkbook.Save
    Workbooks("BAJAS_ALTAS.XLSX").Save
    Workbooks("BAJAS_ALTAS.XLSX").Close
    Workbooks(A�o & mes & " MAESTRO ACTIVOS" & ".xlsx").Activate
    
    'Dividir por grupo de personal
    lastRow_A = ActiveSheet.Cells(ActiveSheet.Rows.Count, "A").End(xlUp).row
    For x = 1 To lastRow_A
        If Cells(x, "V").Value = "Subcontratado Extern" Then
            Rows(x).Resize(2).Insert Shift:=xlDown
            Exit For
        End If
    Next x
    
    'Hace el ContarA
    lastRow_A = ActiveSheet.Cells(1, "A").End(xlDown).row + 1
    Range("B" & lastRow_A).Formula = "=COUNTA(C2:C" & lastRow_A - 1 & ")"
    With Range("B" & lastRow_A)
        .Interior.Color = RGB(255, 255, 0)
        .Font.Bold = True
        .HorizontalAlignment = xlCenter
    End With
    ActiveWorkbook.Save
        
       
'----------------------------------- Trae la hoja del archivo de la zhr929 -----------------------------------

 MsgBox "Por favor selecciene el archivo de la ZHR929 descargado anteriormente.", vbInformation
    ruta_maestroA = Application.GetOpenFilename("Archivos Excel (*.xls; *.xlsx), *.xls; *.xlsx")
    Application.AskToUpdateLinks = False
    
    ' Abre el reporte seleccionado por el usuario y copiia la primera hoja
    If ruta_maestroA <> "Falso" Then
            
            Set MAESTRO = Workbooks.Open(Filename:=ruta_maestroA, UpdateLinks:=0)
            MAESTRO.Activate
            Worksheets(1).Activate
            Columns("A:CJ").Select
            Selection.Copy
            
            'Crea el archivo nuevo
            Workbooks(A�o & mes & " MAESTRO ACTIVOS" & ".xlsx").Activate
            Sheets("ZHR929").Activate
            ActiveSheet.Range("A1").PasteSpecial Paste:=xlPasteAll
            Columns("A:CJ").AutoFit
            Application.CutCopyMode = False
            Workbooks(A�o & mes & " MAESTRO ACTIVOS" & ".xlsx").Save
            MAESTRO.Save
            MAESTRO.Close
        
    End If
    Workbooks(A�o & mes & " MAESTRO ACTIVOS" & ".xlsx").Activate
    
    'Cambiar de texto a numero
    Dim rng As Range
    Dim cell As Range
    Set rng = ActiveSheet.Range("A:A").SpecialCells(xlCellTypeConstants, xlTextValues)
    For Each cell In rng
        cell.Value = Val(cell.Value)
    Next cell
    Range("A1").Value = "N�mero de personal"
    
    'Pone condicional de duplicados - los se�ala de rojo
    Columns("A:A").Select
    Selection.FormatConditions.AddUniqueValues
    Selection.FormatConditions(Selection.FormatConditions.Count).SetFirstPriority
    Selection.FormatConditions(1).DupeUnique = xlDuplicate
    With Selection.FormatConditions(1).Font
        .Color = -16383844
        .TintAndShade = 0
    End With
    With Selection.FormatConditions(1).Interior
        .PatternColorIndex = xlAutomatic
        .Color = 13551615
        .TintAndShade = 0
    End With
    Selection.FormatConditions(1).StopIfTrue = False
    
    'Elimina registros duplicados
    lastRow_A = Cells(Rows.Count, "A").End(xlUp).row
    For i = lastRow_A To 2 Step -1
        If Cells(i, "A").Value = Cells(i - 1, "A").Value Then
            Rows(i).Delete
        End If
    Next i
    Workbooks(A�o & mes & " MAESTRO ACTIVOS" & ".xlsx").Save
    
    'Hace el ContarA
    lastRow_A = Cells(Rows.Count, "A").End(xlUp).row
    Range("B" & lastRow_A + 1).Formula = "=COUNTA(B2:B" & lastRow_A & ")"
    With Range("B" & lastRow_A + 1)
        .Interior.Color = RGB(255, 255, 0)
        .Font.Bold = True
        .HorizontalAlignment = xlCenter
    End With
    ActiveWorkbook.Save
        
          
'----------------------------------- ORGANIZA LA HOJA SALARIAL  -----------------------------------
    
    'Cambia formatos de la hoja
    Sheets("SALARIAL").Activate
    ActiveSheet.Cells.Interior.ColorIndex = xlNone
    With Range("A1:AT1")
        .Interior.Color = RGB(118, 215, 196)
        .Font.Bold = True
        .HorizontalAlignment = xlCenter
    End With
    Columns("A:AT").AutoFit
    
    'Cambia de texto a numero
    Set rng = ActiveSheet.Range("A:A").SpecialCells(xlCellTypeConstants, xlTextValues)
    For Each cell In rng
        cell.Value = Val(cell.Value)
    Next cell
    Range("A1").Value = "N� pers."
    
    
    'Condicional de duplicados - Los se�ala con rojo
    Columns("A:A").Select
    Selection.FormatConditions.AddUniqueValues
    Selection.FormatConditions(Selection.FormatConditions.Count).SetFirstPriority
    Selection.FormatConditions(1).DupeUnique = xlDuplicate
    With Selection.FormatConditions(1).Font
        .Color = -16383844
        .TintAndShade = 0
    End With
    With Selection.FormatConditions(1).Interior
        .PatternColorIndex = xlAutomatic
        .Color = 13551615
        .TintAndShade = 0
    End With
    Selection.FormatConditions(1).StopIfTrue = False
    
    'Elimina registros duplicados
    lastRow_A = Cells(Rows.Count, "A").End(xlUp).row
    For i = lastRow_A To 2 Step -1
        If Cells(i, "A").Value = Cells(i - 1, "A").Value Then
            Rows(i).Delete
        End If
    Next i
    
    'Hacer el ContarA
    lastRow_A = Cells(Rows.Count, "B").End(xlUp).row
    Range("B" & lastRow_A + 1).Formula = "=COUNTA(B2:B" & lastRow_A & ")"
    With Range("B" & lastRow_A + 1)
        .Interior.Color = RGB(255, 255, 0)
        .Font.Bold = True
        .HorizontalAlignment = xlCenter
    End With
    ActiveWorkbook.Save
        
    'Traer el valor de la ZHR929 del contarA
    Dim lastRowZHR As Long
    Dim valor As Variant
    lastRowZHR = Sheets("ZHR929").Cells(Sheets("ZHR929").Rows.Count, "B").End(xlUp).row
    valor = Sheets("ZHR929").Cells(lastRowZHR, "B").Value
    lastRow_A = Sheets("SALARIAL").Cells(Sheets("SALARIAL").Rows.Count, "B").End(xlUp).row
    Sheets("SALARIAL").Cells(lastRow_A + 1, "B").Value = valor

    With Range("B" & lastRow_A + 1)
        .Interior.Color = RGB(50, 255, 252)
        .Font.Bold = True
        .HorizontalAlignment = xlCenter
    End With
    
    'Realiza el restar
    lastRow_A = Cells(Rows.Count, "B").End(xlUp).row
    Range("B" & lastRow_A + 1).Value = Range("B" & lastRow_A - 1).Value - Range("B" & lastRow_A).Value
    With Range("B" & lastRow_A + 1)
        .Font.Bold = True
        .HorizontalAlignment = xlCenter
    End With
       
       
        
 '----------------------------------- ORGANIZ EL ORDEN DE LOS CAMPOS DE LA HOJA SALARIAL -----------------------------------
    
    'Inserta 48 columnas nuevas
    Sheets("SALARIAL").Activate
    Columns("C:C").Insert Shift:=xlToRight, CopyOrigin:=xlFormatFromLeftOrAbove
    Columns("D:D").Insert Shift:=xlToRight, CopyOrigin:=xlFormatFromLeftOrAbove
    Range("C1").Value = "NETO NOMINA FONDOS"
    Range("D1").Value = "RETROACTIVIDAD"
    Columns("E:E").Resize(, 46).Insert Shift:=xlToRight

    '------- Inicia a copiar y pegar columnas --------
    
    'ReLab y Relaci�n laboral
    Range("AY:AZ").Select
    Selection.Copy
    Range("E:E").Select
    Selection.PasteSpecial Paste:=xlPasteValues, Operation:=xlNone, SkipBlanks _
        :=False, Transpose:=False
    Application.CutCopyMode = False
    
    '�.liq. y �rea de n�mina
    Range("CN:CO").Select
    Selection.Copy
    Range("G:G").Select
    Selection.PasteSpecial Paste:=xlPasteValues, Operation:=xlNone, SkipBlanks _
        :=False, Transpose:=False
    Application.CutCopyMode = False
    
    'CC-n�mina y CC-n�mina14
    Range("CD:CE").Select
    Selection.Copy
    Range("I:I").Select
    Selection.PasteSpecial Paste:=xlPasteValues, Operation:=xlNone, SkipBlanks _
        :=False, Transpose:=False
    Application.CutCopyMode = False
    
    'Importe Y Importe16
    Range("CF:CG").Select
    Selection.Copy
    Range("K:K").Select
    Selection.PasteSpecial Paste:=xlPasteValues, Operation:=xlNone, SkipBlanks _
        :=False, Transpose:=False
    Application.CutCopyMode = False
    
    'ClFe,Clase de fecha, fecha
    Range("BO:BQ").Select
    Selection.Copy
    Range("O:O").Select
    Selection.PasteSpecial Paste:=xlPasteValues, Operation:=xlNone, SkipBlanks _
        :=False, Transpose:=False
    Application.CutCopyMode = False
    
    'Ce.coste y Centro de coste
    Range("BA:BB").Select
    Selection.Copy
    Range("R:R").Select
    Selection.PasteSpecial Paste:=xlPasteValues, Operation:=xlNone, SkipBlanks _
        :=False, Transpose:=False
    Application.CutCopyMode = False
    
    'GrPer   Grupo de personal   �Pers   �rea de personal
    'Posici�n    Posici�n    Funci�n Funci�n DivP    Divisi�n de personal
    'Clase de identificaci�n (clase  N�mero ID
    Range("BC:BN").Select
    Selection.Copy
    Range("T:T").Select
    Selection.PasteSpecial Paste:=xlPasteValues, Operation:=xlNone, SkipBlanks _
        :=False, Transpose:=False
    Application.CutCopyMode = False
    
    'Fecha nac.  Edad del empleado   Sexo    Clave de sexo
    'CC  Clase de contrato   Soc.    Sociedad    Div.    Divisi�n
    'S   Status ocupaci�n
    Range("BR:CC").Select
    Selection.Copy
    Range("AF:AF").Select
    Selection.PasteSpecial Paste:=xlPasteValues, Operation:=xlNone, SkipBlanks _
        :=False, Transpose:=False
    Application.CutCopyMode = False
    
    'VP  V�a de pago Clave banco Clave de banco
    '�re �rea de convenio
    Range("CH:CM").Select
    Selection.Copy
    Range("AR:AR").Select
    Selection.PasteSpecial Paste:=xlPasteValues, Operation:=xlNone, SkipBlanks _
        :=False, Transpose:=False
    Application.CutCopyMode = False
    
    'Cuenta bancaria
    Range("CP:CP").Select
    Selection.Copy
    Range("AX:AX").Select
    Selection.PasteSpecial Paste:=xlPasteValues, Operation:=xlNone, SkipBlanks _
        :=False, Transpose:=False
    Application.CutCopyMode = False
    
    'Cambia de texto a numero
    Set rng = ActiveSheet.Range("AX:AX").SpecialCells(xlCellTypeConstants, xlTextValues)
    For Each cell In rng
        cell.Value = Val(cell.Value)
    Next cell
    Range("AX1").Value = "Cuenta bancaria"
    
    'Eliminar lo que no sirve
    Range("AY:CP").Select
    Selection.Delete
    Columns("A:AX").AutoFit
    ActiveWorkbook.Save
    
    'Color columnas M y N
    Range("M1:N1").Interior.Color = RGB(244, 208, 63)
    Range("M1").Value = "SALARIO MES ANTERIOR"
    Range("N1").Value = "DIFERENCIA"
    Columns("Q:Q").NumberFormat = "DD/MM/YYYY"
    
       
'----------------------------------- TRAE EL VALOR DEL SALARIO DEL MES ANTERIOR -----------------------------------
    
    MsgBox "Por favor abra el maestro del mes anterior para extraer el valor del salario.", vbInformation
    ruta_maestroA = Application.GetOpenFilename("Archivos Excel (*.xls; *.xlsx), *.xls; *.xlsx")
    Application.AskToUpdateLinks = False
    
    ' Abre el reporte seleccionado
    If ruta_maestroA <> "Falso" Then
            
            Set MAESTRO = Workbooks.Open(Filename:=ruta_maestroA, UpdateLinks:=0)
            MAESTRO.Activate
            Worksheets("SALARIAL").Activate
            On Error Resume Next
            ActiveSheet.ShowAllData
            On Error GoTo 0
            Columns("A:M").Select
            Selection.Copy
            
            'Trae la columna necesaria
            Workbooks(A�o & mes & " MAESTRO ACTIVOS" & ".xlsx").Activate
            Sheets("MAESTRO MES ANTERIOR").Activate
            ActiveSheet.Range("A1").PasteSpecial Paste:=xlPasteAll
            Columns("A:M").AutoFit
            Application.CutCopyMode = False
            Workbooks(A�o & mes & " MAESTRO ACTIVOS" & ".xlsx").Save
            MAESTRO.Save
            MAESTRO.Close
        
    End If
    
    'Hace el buscarv
    Workbooks(A�o & mes & " MAESTRO ACTIVOS" & ".xlsx").Activate
    Sheets("SALARIAL").Activate
    Columns("M").NumberFormat = "General"
    Columns("N").NumberFormat = "General"
    lastRow_A = Cells(Rows.Count, "A").End(xlUp).row
    Range("M2:M" & lastRow_A) = "=VLOOKUP(RC[-12],'MAESTRO MES ANTERIOR'!C[-12]:C,11,0)"
'    Range("M:M").Copy
'    Range("M:M").PasteSpecial Paste:=xlPasteValues
    Application.CutCopyMode = False
'    Application.DisplayAlerts = False
'    Sheets("MAESTRO MES ANTERIOR").Delete
'    Application.DisplayAlerts = True
    Sheets("MAESTRO MES ANTERIOR").Visible = xlSheetHidden
    ActiveWorkbook.Save
    
    'Hace el calculo de la diferencia entre los salarios
    Range("N2:N" & lastRow_A) = "=K2-M2"
    
    'Formatos
    Columns("K").NumberFormat = "$#,##0"
    Columns("M").NumberFormat = "$#,##0"
    Columns("N").NumberFormat = "General"
    Columns("N").NumberFormat = "$#,##0"
    Columns("A:AX").AutoFit
    Rows(lastRow_A + 1).Insert Shift:=xlDown, CopyOrigin:=xlFormatFromLeftOrAbove
    
    
'---------------------- ORGANIZAR LA HOJA "NO SALARIAL" ----------------------
    
    'Cambia formatos de la hoja
    Sheets("NO SALARIAL").Activate
    ActiveSheet.Cells.Interior.ColorIndex = xlNone
    With Range("A1:AT1")
        .Interior.Color = RGB(250, 215, 160)
        .Font.Bold = True
        .HorizontalAlignment = xlCenter
    End With
    Columns("A:AT").AutoFit
    
    'Cambia de texto a numero
    Set rng = ActiveSheet.Range("A:A").SpecialCells(xlCellTypeConstants, xlTextValues)
    For Each cell In rng
        cell.Value = Val(cell.Value)
    Next cell
    Range("A1").Value = "N� pers."
    
    'Condicional de duplicados - Los se�ala con rojo
    Columns("A:A").Select
    Selection.FormatConditions.AddUniqueValues
    Selection.FormatConditions(Selection.FormatConditions.Count).SetFirstPriority
    Selection.FormatConditions(1).DupeUnique = xlDuplicate
    With Selection.FormatConditions(1).Font
        .Color = -16383844
        .TintAndShade = 0
    End With
    With Selection.FormatConditions(1).Interior
        .PatternColorIndex = xlAutomatic
        .Color = 13551615
        .TintAndShade = 0
    End With
    Selection.FormatConditions(1).StopIfTrue = False
    
    'Hace el ContarA
    lastRow_A = Cells(Rows.Count, "A").End(xlUp).row
    Range("B" & lastRow_A + 2).Formula = "=COUNTA(B2:B" & lastRow_A & ")"
    With Range("B" & lastRow_A + 2)
        .Interior.Color = RGB(255, 255, 0)
        .Font.Bold = True
        .HorizontalAlignment = xlCenter
    End With
    ActiveWorkbook.Save
    
    'Filtra en salarial para copiar los numeros de empleados
    Sheets("SALARIAL").Activate
    Rows("1:1").AutoFilter Field:=6, Criteria1:="=Ley 50"
    Rows("1:1").AutoFilter Field:=25, Criteria1:="<>TRAINEE"
    lastRow_A = Cells(Rows.Count, "A").End(xlUp).row
    
    'Copia y pega
     Range("A1:A" & lastRow_A).Select
    Selection.SpecialCells(xlCellTypeVisible).Copy
    Sheets("NO SALARIAL").Activate
    lastRow_A = Cells(Rows.Count, "A").End(xlUp).row
    Range("A" & lastRow_A + 4).PasteSpecial Paste:=xlPasteValues
    Range("A" & lastRow_A + 4).Value = "MAESTRO"
    Range("A" & lastRow_A + 4).Interior.Color = RGB(50, 215, 160)
    
    'Finaliza
    Sheets("SALARIAL").Activate
    ActiveSheet.AutoFilterMode = False
    Sheets("ORIGINAL").Activate
    ActiveSheet.AutoFilterMode = False
    ActiveWorkbook.Save
    ActiveWorkbook.Close
      
    Else
        MsgBox "Operaci�n cancelada por el usuario.", vbInformation
    End If

End Sub


