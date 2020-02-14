clc
clear all
close all
probID = 'P011'
probmatthias = strrep(probID,'P','p')

matthias_left = strcat (probmatthias,'_l');
druckbilder= 0; % 0 ohne 1 mit wenn 0 geht es schneller

EMEDRight = importfile1(strcat('C:\Users\maipa\Downloads\Test_Data_Report\Test_Data_Report\EMED_Discrete\',probmatthias, '.lst'), 17,166);
EMED_load_matthias

EMEDLEFT = importfile1(strcat('C:\Users\maipa\Downloads\Test_Data_Report\Test_Data_Report\EMED_Discrete_L\',matthias_left, '.lst'), 17,166);
EMEDL_load_matthias

%emed
path.EMED = (strcat('C:\Users\maipa\Downloads\Test_Data_Report\Test_Data_Report\EMED\',probID));
datatemp = dir(fullfile(path.EMED , '*.lst'));
%the rights
IndexR = find(contains({datatemp.name},'r'));
Rights = datatemp;
Rights = datatemp ([IndexR],:);
Lefts = datatemp;
%the left
Lefts([IndexR],:) = [];
%%

%filenameL = strcat('C:\Users\maipa\Downloads\Test_Data_Report\Test_Data_Report\EMED\',probID,'\',Lefts(2).name);
%filenameR = strcat('C:\Users\maipa\Downloads\Test_Data_Report\Test_Data_Report\EMED\',probID,'\',Rights(1).name);
stlye = {'-', '-', '-', '-', '-', '-', '-'};
farbe = {[0 0 0]	, [65 105 225]/255	, [220,20,60]/255	 ,[0.4940 0.1840 0.5560]	, [0.4660 0.6740 0.1880]	, [0.3010 0.7450 0.9330],	[0 0 0]};
Height = '4in';
Witdth = '5in';

try
    cd ( strcat('C:\Users\maipa\Desktop\', probID))
catch
    mkdir  ( strcat('C:\Users\maipa\Desktop\', probID))
    cd ( strcat('C:\Users\maipa\Desktop\', probID))
end
% %first load all the data
%ANKLES and MOMENTS
DATA.KandK = load('C:\Users\maipa\Desktop\Alltogether\ProbMeanCurves.mat');
DATA.GRF = load('C:\Users\maipa\Desktop\Alltogether\ProbMeanCurvesGRF.mat');
DATA.DISCRTE= load('C:\Users\maipa\Desktop\Alltogether\Discrete.mat');
DATA.Zehenkraft = load('C:\Users\maipa\Desktop\torques.mat');
DATA.AbisCDiscrete =load('C:\Users\maipa\Desktop\Alltogether\DiscreteAbisC.mat');



path.BODYSCANNER = (strcat('C:\Users\maipa\Downloads\Test_Data_Report\Test_Data_Report\BODYSCANNER\',probID,'\',probID,'.stl'));
%load stl file
%stlload stuff goes in here

%load foot scanner folder left and right
folder.FOOTSCANNER=(strcat('C:\Users\maipa\Downloads\Test_Data_Report\Test_Data_Report\FOOTSCANNER\', probID, '\'));
%list only stl files
fsfiles = dir(fullfile(folder.FOOTSCANNER, '*.stl'));
fsfiles = fsfiles(arrayfun(@(x) ~strcmp(x.name(1),'.'),fsfiles));
%identify right
IndexR = find(contains({fsfiles.name},'r'));
rightfoot = strcat(fsfiles(IndexR).folder,'\',fsfiles(IndexR).name);
try
    leftfoot = strcat(fsfiles(IndexR).folder,'\',fsfiles(IndexR-1).name);
catch
    leftfoot = strcat(fsfiles(IndexR).folder,'\',fsfiles(IndexR+1).name);
end
%load left and right
%stlload stuff goes in here
%

%load some demografics
get_demo
demoofsubjectrow =find (contains (DATA.patientdata.ID, probID));
mass = DATA.patientdata.BWmeasured(demoofsubjectrow,1);
height = DATA.patientdata.Gre(demoofsubjectrow,1);
gender =DATA.patientdata.Geschlecht(demoofsubjectrow,1);
if gender =='m'
    geschlecht='m�nnlich';
else
    geschlecht ='weiblich';
end
vorname = DATA.patientdata.Vorname(demoofsubjectrow,1);
nachname = DATA.patientdata.Nachname(demoofsubjectrow,1);
[Imale, M] = find (DATA.patientdata.Geschlecht=='m');
[Ifemale, M] = find (DATA.patientdata.Geschlecht=='f');

toestrengthmale = nanmean( (cell2mat(DATA.Zehenkraft.toe_strength([Imale],4))));
toestrengthfemale = nanmean( (cell2mat(DATA.Zehenkraft.toe_strength([Ifemale],4))));
zehenkraftprob = (cell2mat(DATA.Zehenkraft.toe_strength([demoofsubjectrow],4)));


%% here starts the repot

import mlreportgen.report.*
import mlreportgen.dom.*


%%%%%% some additional texts


paraDanke = Paragraph(['Sehr geehrte Damen und Herren, vielen lieben Dank, dass Sie an der Laufstudie des Institutes f�r Biomechanik und Orthop�die der Deutschen Sporthochschule K�ln teilgenommen haben. Ihr Einsatz hilft dabei individuelle Laufverhalten besser zu verstehen. Hierdurch k�nnen zuk�nftig �berbelastungsverletzungen besonders im Knie, H�ft und Sprunggelenk pr�ventiv reduziert und minimiert werden. Dadurch profitieren nicht nur Sie selbst, sondern auch L�uferinnen und L�ufer rund um den Globus. ']);
paraZiel = Paragraph(['Ziel der Studie, an der Sie als Proband teilgenommen haben, was es, den Einfluss von verschiedenen Mittelsohlensteifigkeit auf die Laufmechanik zu bestimmen.  Hierf�r wurden mit Hilfe eines 3D-Bewegungsanalysesystems die Bewegung des K�rpers beim Laufen aufgenommen. Diese aufgezeichnet Daten sollen uns unteranderem dabei helfen ein besseres Verst�ndnis bez�glich biomechanischer Parameter f�r das Herstellen von individuellen Laufschuhen zu erlangen. Zu beginn der Untersuchung wurden Ihnen 78 reflektierende Marker an definierten anatomischen Punkten auf die Haut aufgeklebt. Diese Marker wurden von unserem Infrarotlicht-basierten Kamerasystem detektiert und aufgenommen. Mithilfe der digitalisierten Marker Positionen konnten wir sp�ter die Bewegungsanalyse durchf�hren.'...
    'Des Weiteren wurden Bodenreaktionskr�fte entlang der Laufstrecke mittels Kraftmessplatte, welche in den Boden eingelassen waren erfasst. Zus�tzlich wurde die Druckverteilung des Fu�es beim Gehen und langsamen Laufen mittels einer in den Boden eingelassen Druckmessplatte erfasst. Au�erdem wurde die Anthropometrie des Fu�es und des gesamten K�rpers mittels eines 3-dimensionalen Oberfl�chenscans erfasst. Dar�ber hinaus wurden maximale Muskelkr�fte der Zehenflexoren w�hrend isometrischer Bedingungen bestimmt. Diese zus�tzlichen Messungen sollten uns dabei helfen ein besseres Verst�ndnis dar�ber zu erlangen welche Einflussfaktoren das individuelle Laufverhalten beeinflussen k�nnen. Die gesamten Messungen wurden an einem Termin durchgef�hrt und haben etwa 3 bis maximal 4 Stunden in Anspruch genommen.']);


paraZielBericht = Paragraph(['Ziel dieses beiliegenden Laufberichtes ist es, Ihnen ein besseres Verst�ndnis �ber Ihr eigenes Laufverhalten zu vermitteln. Hierzu haben wir Ihnen eine �bersicht der wichtigsten laufrelevanten Parameter und deren Einfluss auf das Laufverhalten im Zusammenhang mit laufbedingten �berbelastungsverletzungen zusammengestellt. Diese k�nnen in den folgenden Kapiteln eingesehen werden. Diese Parameter sind allerdings vor dem Hintergrund der Individualit�t jedoch mit Vorsicht zu interpretieren. Erh�hte Belastungen bedeuten daher nicht ausnahmslos, dass Sie ein erh�htes Verletzungsrisiko besitzen.']);

paraInfoZehen = Paragraph(['Eine Vielzahl wissenschaftlicher Publikationen haben gezeigt, dass die Zehenkraft in Korrelation mit der Gesamtstabilit�t des Fu�es zusammenh�ngt. Diese hat Einfluss auf die Deformation des Fu�gew�lbes w�hrend des Gehens und Laufens. Eine st�rkere Zehenkraft f�hrt in der Regel zu einer geringeren Deformation des Fu�gew�lbes und kann so Laufverletzung pr�ventiv beeinflussen. Des Weiteren ist die Zehenkraft auch ein wichtiger Performanceindikator. Beispielsweise hat die Zehenkraft Einfluss auf das Abdruckverhalten beim Laufen und Springen. Diese Kraft wird unter anderem aus der extrinsischen Fu�muskulatur (Wadenmuskutlatur) generiert und �ber Sehnen auf das Zehengrundgelenk �bertragen. ']);


paraEMEDinfo = Paragraph(['Mittels der aus insgesamt �ber 6000 einzelnen kapazitiven Sensoren bestehenden Druckmessplatte kann die Druckverteilung des Fu�es sowohl w�hrend dynamischer als auch statischer Bewegungen gemessen werden. Im Gegensatz zu den statischen Messungen haben dynamische Messungen den Vorteil, dass das Gangbild in unterschiedlichen Bewegungsphasen genau beobachtet werden kann. So kann beispielweise die Verformung des Fu�gew�lbes w�hrend der Bewegung bestimmt werden. Unter anderem kann somit auch ein Links-Rechts-Vergleich der Druckbilder w�hrend der Belastung aufgezeigt werden. Dies kann asymmetrische Druckbilder identifizieren.']);


para3DKoerperscanninfo= Paragraph(['Sowohl der 3D- K�rperscan als auch der 3D-Fussscan erm�glicht es genaue Angaben �ber die K�rperoberfl�che, die Massenmittelpunkte und weitere anthropometrische Eigenschaften des K�rpers machen zu k�nnen. Diese k�nnten wiederum dazu genutzt werden, um beispielsweise mittels Machine Learning Hervorsagen �ber Verletzungsrisikos und Laufpr�ferenzen machen zu k�nnen. Hierbei steht die Wissenschaft allerdings noch am Anfang der Forschung, sodass wir Ihnen hierzu keine weiteren Informationen geben k�nnen. Bisher haben wir diese Daten noch nicht genauer analysieren k�nnen.']);


para3DFussscanninfo = Paragraph([' ']);

paraEMEDPersonal = Paragraph([' ']);



paraGRF = Paragraph(['In der Biomechanik k�nnen wir die Kr�fte, die auf ein Menschen wirken sehr genau messen. Diese Kr�fte, auch externe Kr�fte genannt, k�nnen beispielweise mittels in den Boden eingelassenen Kraftmessplatten gemessen werden. Die Kraft kann somit als eine 3D-Gr��e erfasst werden. Man unterscheidet in vertikaler Bodenreaktionskraft (senkrecht), Reaktionskr�fte die seitlich wirken (medial / lateral), und Kr�fte die nach vorn und hinten wirken (posterior / anterior). Die Kr�fte werden f�r die Berechnung von Gelenksbelastung (Drehmomente) ben�tigt, hierzu mehr im nachfolgenden Kapitel']);
paraKINEMATIKinfo = Paragraph(['Gelenkskinematik beschreibt die Bewegung verschiedener benachbarter K�rpersegmente (z.B. Ober- und Unterschenkel) im 3D-Raum. Somit k�nnen Gelenkswinkel in allen 3 Raumachsen beschreiben werden. Man unterscheidet zwischen Sagittal- (Flexion, Extension), Frontal- (Abduktions, Adduktion) und Transversalebene (interne, externe Rotation). Zus�tzlich sei zu erw�hnen das Fronalebenenbewegung am Fuss oftmals mit dem Term Eversion und Inversion beschrieben werden.']);
paraKINETIKinfo = Paragraph(['Gelenksdrehmomente ist das Produkt auf Kraft mal Hebelarm und stellen die Belastung am Gelenks w�hrend der Bewegung dar. Drehmomente wie beispielsweise das Knieabduktionsmoment zeigen auch einen Zusammenhang mit �berbelastungsverletzungen im Laufsport. In einer vielzahl von wissenschaftlichen Studien wurde jedoch auch schon gezeigt das sich Drehmomente an Gelenken durch Ver�nderungen des Schuhwerks erzielen lassen. Die untenstehende Grafik soll dieses Prinzip verdeutlichen. Die (externe) Kraft und die Entfernung zum Gelenkszentrum (Hebelarm) erzeugen ein Drehmoment (extern), dieses Drehmoment l�sst sich durch umorientierung der Kraft (Ver�nderung des Kraftangriffspunkt, Schnittstelle Laufschuh und Boden) ver�ndern. Bitte beachten Sie das wir im folgenden auf die internen Drehmomente der Gelenke verweissen. Interne Momente werden durch Ligamenten, B�ndern, Sehen und Muskeln erzeugt und wirken den externen Drehmomenten entgegegen, sie sind daher nur in ihrem Vorrzeichen vertauscht.']);
paraSCHUHINFO = Paragraph(['In dieser Studie wurden unter anderem der Einfluss unterrschiedlicher Schuhe auf die Laufbiomechanik getestet. Bei dieser Studie handelte es sich um eine Blindstudie. Das hei�t, Sie als Teilnehmer wussten zu dem Zeitpunkt der Messungen nicht, welche Faktoren an den Laufschuhen ver�ndert wurden sind. Im Nachhinein soll nun auf drei der ingesamt sieben getesteten Schuhe n�her eingegangen werden. Die Schuhe A, B und C sind zur Veranschaulichung in der untenstehenden Grafik dargestellt. In der untenstehenden Grafik sehen Sie die drei experimentelen Schuhbedingungen (Mittelsohlen) in der Draufsicht. Dabei wurde systematisch die H�rteverteilung im R�ckfuss ver�ndert. Die schwarzen Punkte zeigen hierbei harte Elemente, grau weniger harte und wei� weiche Elemente. Die genauen H�rtegrade sind in der Rockwell (C) angeben. Mittels dieser Methode lassen sich so beispielsweise individualisierte Laufschuhe auf die Bed�rfnisse eines/einer L�ufers*in herstellen und so m�glicherweise laufbedingte �berbelastungsverletzungen reduzierenx. Dies kann gegenenfalls auch zur Leistungssteigerung beitragen.    ']);
para3DBewegungInfo = Paragraph(['Bei dieser Studie wurden verschiedene Systeme zur Erfassung von Bewegungen des menschlichen Bewegungsapparates (�Motion Capturing�) eingesetzt. Diese Systeme messen die drei S�ulen der Biomechanik, als Fachbegriff f�r die Wissenschaft der Bewegungserfassung. Diese drei S�ulen bilden die K�rperma�e (Anthropometrie), die Bewegung (Kinematik) und die Kraft (Kinetik). Die erfassten Daten wurden zeitsynchron aufgezeichnet, um sie sp�ter in ihrem Zusammenhang auswerten zu k�nnen: Die K�rperma�e sind die Grundlage f�r die Auswertung des verwendeten Marker-basierten Kamerasystems, welches die dreidimensionale Bewegung des K�rpers und der Extremit�ten im Raum auf einige Millimeter genau ermitteln kann. Werden zus�tzlich zeitgleich die Bodenreaktionskr�fte mittels 3D Kraftmessplatten gemessen, kann �ber Kalkulationen der Gelenkmittelpunkt, Kraftangriffspunkte und demnach Hebelarme und Gelenkbelastung gemessen werden. Die Gelenkbelastung ist somit abh�ngig von auftretenden Kr�ften und Bewegungsver�nderungen, die ma�geblich durch das Schuhwerk beeinflusst werden k�nnen. Mit Hilfe von Motion Capture Systemen k�nnen somit Aussagen zum Einfluss der verschiedenen Laufschuhe auf den Bewegungsapparat beispielsweise zur Verletzungspr�vention oder der Optimierung der Performance getroffen werden.']);


%%%%%% end of additional text
rpt = Report(probID,'pdf');
tp = TitlePage;
tp.Title = 'Studie zum individuellen Laufverhalten und zur Individualisierung von Laufschuhtechnologie basierend auf systematische Ver�nderung der Mittelsohlensteifigkeit ';
tp.Subtitle = '3-Dimensionale Bewegungsanalyse';
tp.Author = '';
% Create a sample image
im = Image(which('Logo_DSHS_Koeln.png'));
im.Width = '0.75in';
im.Height = '0.75in';

header = PDFPageHeader();
append(header, im);

% Get the report's page layout and set header
layout = getReportLayout(rpt);
layout.PageHeaders = header;

figure()
tp.Image =('C:\Users\maipa\Desktop\running_man.png');
axis('image');
% set(gca,'Xtick',[],'Ytick',[],...
% 'Units','normal','Position',[0 0 1 1]);
close gcf

add(rpt,tp);




close gcf


add(rpt,TableOfContents);  % add table of content
ch1 = Chapter;
ch1.Title = 'Hintergrundinformationen';
sec0=Section;
sec0.Title = 'Danksagung';
paraDanke.Style = {HAlign('justify')}; %mache blocksatz
add(sec0,paraDanke) %add the paragraph to the section
add(ch1,sec0) %add the section to the chapter


sec1 = Section;
sec1.Title = 'Ziel der Studie';
paraZiel.Style = {HAlign('justify')}; %mache blocksatz
add(sec1,paraZiel) %add the paragraph to the section
add(ch1,sec1) %add the section to the chapter

sec2 = Section; %new secion
sec2.Title = 'Ziel des Laufberichtes';
paraZielBericht.Style = {HAlign('justify')}; %mache blocksatz
add(sec2,paraZielBericht)
add(ch1,sec2)
add(rpt,ch1) %add the chapter handle to the report handle


ch2 = Chapter();
ch2.Title = ('Pers�nliche Informationen');
sec20 = Section; %new secion
sec20.Title = 'Body Mass Index';

parav=[(strcat ('Name:',{' '}, vorname,{' '}, nachname))];
% paran=[];
paraa=[(strcat ('Alter:',{' '}, num2str((DATA.patientdata.Alter(demoofsubjectrow,1)))))];
paragewicht=[(strcat ('K�rpergewicht:',{' '}, num2str((round(DATA.patientdata.BWmeasured(demoofsubjectrow,1),1))),'kg'))];
paragroesse=[(strcat ('K�rpergr��e:',{' '}, num2str((DATA.patientdata.Gre(demoofsubjectrow,1))), 'm'))];
BMI = DATA.patientdata.BWmeasured(demoofsubjectrow,1)/(DATA.patientdata.Gre(demoofsubjectrow,1))^2;

paraBMI=([(strcat ('Body Mass Index (BMI):',{' '}, num2str(round(BMI,1))))]);
% paraBMI.Style = {Bold(true)};



%link zu BMI https://www.bmi-rechner.biz/
fig = Figure(gcf);
fig.Snapshot.Caption = sprintf('Der Body Mass Index (BMI) �Ma�zahl f�r die Bewertung des K�rpergewichts eines Menschen in Relation zu seiner K�rpergr��e, weitere Informationen zu diesen Thema finden Sie unter https://www.bmi-rechner.biz/');
imshow ('C:\Users\maipa\Desktop\bmi.png')
% fig.Style = [fig.Style(:)' {halign}];

add(sec20,parav) %old fashion and shity methode
% add(sec20,paran)
add(sec20,paraa)
add(sec20,paragewicht)
add(sec20,paragroesse)
add(sec20,paraBMI)


add(sec20,fig);  % add the fig to chapter 2 BMI
add(ch2,sec20) %add sec20 to chapter 2
add(rpt,ch2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ch3 = Chapter();
ch3.Title = sprintf('Zehenkraft, Druckverteilung und Antropometrie');
sec30 = Section; %new secion
%%%%% Zehenkraft
sec30.Title = 'Zehenkraft';



paraInfoZehen.Style = {HAlign('justify')}; %mache blocksatz
add(sec30,paraInfoZehen) %add the paragraph to the section

figure()
b=bar ([toestrengthfemale, toestrengthmale]);
b.FaceColor = 'flat';
b.CData(1,:)= [240 128 128]/255;
xticks([1 2] )
xticklabels({'Frauen','M�nner'})
ylabel ('Zehenkraft [Nm/kg]')
set(gca,'Fontname','CMU Sans Serif')
set(gca, 'FontSize', 20);
set(gca, 'linewidth', 2)
set(gcf,'color','w');
set(gca, 'FontSize', 20);
box off
hold on
if gender =='m'
    h3= scatter (2,zehenkraftprob,100, 'ro', 'filled');
         text(2.5,zehenkraftprob,num2str(round(zehenkraftprob,2)))

    if zehenkraftprob>toestrengthmale
        temptext =('tendenziell etwas gr��er');
        zusatztext = ('Wir empfehlen Ihnen weiterhin Ihre Zehenkraft so gut zu trainieren. Folgende �bungen k�nnen Sie hierf�r zus�tzlich in Ihren Trainingsplan einbauen https://www.runnersworld.de/krafttraining-stretching/fussmuskulatur-staerken/');
    else
        temptext=('tendenziell etwas niedriger');
        zusatztext = ('Um Ihre Zehenkraft zu trainieren empfehlen wir folgende �bungen https://www.runnersworld.de/krafttraining-stretching/fussmuskulatur-staerken/ ');
        
    end
elseif gender =='f'
    if zehenkraftprob>toestrengthfemale
        temptext = ('tendenziell etwas gr��er');
        zusatztext = ('Wir empfehlen Ihnen weiterhin Ihre Zehenkraft so gut zu trainieren. Folgende �bungen k�nnen Sie hierf�r zus�tzlich in Ihren Trainingsplan einbauen https://www.runnersworld.de/krafttraining-stretching/fussmuskulatur-staerken/');
    else
        temptext =('tendenziell etwas niedriger');
        zusatztext = ('Um Ihre Zehenkraft zu trainieren empfehlen wir folgende �bungen https://www.runnersworld.de/krafttraining-stretching/fussmuskulatur-staerken/ ');
        
    end
    h3=scatter (1,zehenkraftprob,100)
    text(0.1,zehenkraftprob,num2str(round(zehenkraftprob,2)))
    
end
text(0.1,toestrengthfemale,'Mittelwert')
text(2.5,toestrengthmale,'Mittelwert')
text = {'Ihre erreichte maximale Zehenkraft'};
leg = legend ([h3], text,  'interpreter', 'none','FontSize',10);
legend boxoff
add(ch3,sec30)
figZehen = mlreportgen.report.Figure(gcf);
%
figZehen.Snapshot.Caption = ('Die obenstehende Grafik zeigt die Mittelwerte der Zehenkraft getrennt nach Frauen und M�nnern, der rote Punkt zeigt Ihre Zehenkraft im Vergleich zum jeweiligen Gruppenmittelwert.');
figZehen.Snapshot.Height = Height;
figZehen.Snapshot.Width = Witdth;
add(sec30,figZehen);  % add the figure to section
hold off
if gender =='m'
    moderw= ('M�nnern');
elseif gender =='f'
    moderw= ('Frauen');
end

paraZehenWertung = Paragraph([(strcat('Ihre Zehenkraft im Vergleich zu den anderen',{' '},moderw,{' '}, 'ist', {' '},convertCharsToStrings(temptext), {' '},'als der Gruppenmittelwert.',{' '}, zusatztext))]);
paraZehenWertung.Style = {HAlign('justify')}; %mache blocksatz
add(sec30,paraZehenWertung) %add the paragraph to the section

% clf;

%%%%%EMED
sec31 = Section; %new secion
sec31.Title = 'Druckverteilung';

paraEMEDinfo.Style = {HAlign('justify')}; %mache blocksatz

add(sec31,paraEMEDinfo) %add the paragraph to the section

paraEMEDPersonal.Style = {HAlign('justify')}; %mache blocksatz
add(sec31,paraEMEDPersonal) %add the paragraph to the section

add(ch3,sec31)
%%
%%%%Druckbilder
%load matthias data 

clearvars text
figure()

ImagefuesseStatic =('C:\Users\maipa\Desktop\emed_final.png');
h10 = imshow (ImagefuesseStatic);
% axis('image');

rechts = 'Rechts';
text(740,534,rechts);


rechts = 'Links';
text(292,534,rechts);


textzehenlinks = strcat(num2str(round(mean(SL.Peak_Pressure(:,8)),1)), 'kPa');
text(370,70,textzehenlinks);

textzeherechts = strcat(num2str(round(mean(SR.Peak_Pressure(:,8)),1)), 'kPa');
text(573,70,textzeherechts);


textmetlinks = strcat(num2str(round(mean(SL.Peak_Pressure(:,5)),1)), 'kPa');
text(85,158,textmetlinks);


textmetrchts =strcat(num2str(round(mean(SR.Peak_Pressure(:,5)),1)), 'kPa');
text(904,158,textmetrchts);

textmidlinks = strcat(num2str(round(mean(mean(SL.Peak_Pressure(:,3:4),2),1))), 'kPa');
text(394,282,textmidlinks);


textmidrechtds = strcat(num2str(round(mean(mean(SR.Peak_Pressure(:,3:4),2),1))), 'kPa');
text(581,282,textmidrechtds);




texthindmedl = strcat(num2str(round(mean(SL.Peak_Pressure(:,2)),1)), 'kPa');
text(134,427,texthindmedl);



textmidlinks = strcat(num2str(round(mean(SL.Peak_Pressure(:,1)),1)), 'kPa');
text(396,427,textmidlinks);



textmidrechtd =  strcat(num2str(round(mean(SR.Peak_Pressure(:,1)),1)), 'kPa');
text(593,427,textmidrechtd);



texthintrechtsmed = strcat(num2str(round(mean(SR.Peak_Pressure(:,2)),1)), 'kPa');
text(873,427,texthintrechtsmed);

 figDruckFancy = mlreportgen.report.Figure(gcf);
figDruckFancy.Snapshot.Caption = ('Maximaler Druck in den verschiedenen Fu�regionen im Links-Rechts Vergleich. Bitte beachten Sie, dass die Grafik nur f�r Visualisierungszwecke verwendet wurden ist. Die Druckwerte (kPa) entsprechen jedoch Ihren pers�nlichen Werten.');
%     figDruckFancy.Snapshot.Height = Height;
%     figDruckFancy.Snapshot.Width = '6.5in';
add(sec31,figDruckFancy);  % add the figure to section


figure()

areaall1 = sum(SR.Contact_Areas(1,:));
areaall2 = sum(SR.Contact_Areas(2,:));
areaall3 = sum(SR.Contact_Areas(3,:));

proz(1,:) =(SR.Contact_Areas(1,:))/areaall1;
proz1(2,:) =(SR.Contact_Areas(1,:))/areaall2;
proz1(3,:)= (SR.Contact_Areas(1,:))/areaall3;

vector(1,1)= mean ((proz1(:,2)))*100 %verserechtslat
vector(2,1)= mean ((proz1(:,1)))*100 %verserechtsmed
vector(3,1)= mean(sum(proz1(:,3:4),2))*100 %mittelfussrechts
vector(4,1)= mean ((proz1(:,5)))*100 %metarechts1
vector(5,1)= mean ((proz1(:,8)))*100 %bigtoerechts
subplot(1,2,2)
pie (vector)



areaall1 = sum(SR.Contact_Areas(1,:));
areaall2 = sum(SR.Contact_Areas(2,:));
areaall3 = sum(SR.Contact_Areas(3,:));

proz(1,:) =(SR.Contact_Areas(1,:))/areaall1;
proz1(2,:) =(SR.Contact_Areas(1,:))/areaall2;
proz1(3,:)= (SR.Contact_Areas(1,:))/areaall3;

vector(1,1)= mean ((proz1(:,2)))*100 %verserechtslat
vector(2,1)= mean ((proz1(:,1)))*100 %verserechtsmed
vector(3,1)= mean(sum(proz1(:,3:4),2))*100 %mittelfussrechts
vector(4,1)= mean ((proz1(:,5)))*100 %metarechts1
vector(5,1)= mean ((proz1(:,8)))*100 %bigtoerechts
subplot(1,2,2)
pie (vector)


areaall1l = sum(SL.Contact_Areas(1,:));
areaall2l= sum(SL.Contact_Areas(2,:));
areaall3l = sum(SL.Contact_Areas(3,:));

prozl(1,:) =(SL.Contact_Areas(1,:))/areaall1l;
proz1l(2,:) =(SL.Contact_Areas(1,:))/areaall2l;
proz1l(3,:)= (SL.Contact_Areas(1,:))/areaall3l;

vectorL(1,1)= mean ((proz1l(:,2)))*100 %verserechtslat
vectorL(2,1)= mean ((proz1l(:,1)))*100 %verserechtsmed
vectorL(3,1)= mean(sum(proz1l(:,3:4),2))*100 %mittelfussrechts
vectorL(4,1)= mean ((proz1l(:,5)))*100 %metarechts1
vectorL(5,1)= mean ((proz1l(:,8)))*100 %bigtoerechts
subplot(1,2,1)
pie (vectorL)

 figDrucknew = mlreportgen.report.Figure(gcf);
figDrucknew.Snapshot.Caption = ('Anteilige Kontaktfl�chen der einzelnen Fussareale w�hrend der St�tzphase in % der Gesamtfussfl�che. Links-Rechts-Vergleich. ');
%     figDruckFancy.Snapshot.Height = Height;
%     figDruckFancy.Snapshot.Width = '6.5in';
add(sec31,figDrucknew);  % add the figure to section




figure()

Imagefuesseleg =('C:\Users\maipa\Desktop\legendfuss_new.png');
h1222 = imshow (Imagefuesseleg);

 figleg = mlreportgen.report.Figure(gcf);
%
   figleg.Snapshot.Height = '1.5in';
    figleg.Snapshot.Width = '6.5in';
add(sec31,figleg);  % add the figure to section

%%
%here a figure of left and right goes in

sec32 = Section; %new secion
sec32.Title = '3D K�rperscan';

para3DKoerperscanninfo.Style = {HAlign('justify')}; %mache blocksatz
add(sec32,para3DKoerperscanninfo) %add the paragraph to the section


figure()
figBody = mlreportgen.report.Figure(gcf);


[v, f, n, c, stltitle] = stlread2(path.BODYSCANNER);
%slim it, data reduction
[vnew, fnew]=patchslim(v, f);
%flip it
vnew(:,end)=vnew(:,end)*-1;
% f = figure('visible', 'off');
%     figure('units','normalized','outerposition',[0 0 1 1])
subplot(1,3,1)
fv.vertices=vnew;
fv.faces=fnew;
patch(fv,'FaceColor',       [0.8 0.8 1.0],  'EdgeColor',       'none',         'FaceLighting',    'gouraud',       'AmbientStrength', 0.15);
camlight('headlight');
material('dull');
axis('image');
view([90 0]);
set(gca,'visible','off')
subplot(1,3,2)
fv.vertices=vnew;
fv.faces=fnew;
patch(fv,'FaceColor',       [0.8 0.8 1.0],  'EdgeColor',       'none',         'FaceLighting',    'gouraud',       'AmbientStrength', 0.15);
camlight('headlight');
material('dull');
axis('image');
view([180 0]);
set(gca,'visible','off')
subplot(1,3,3)
fv.vertices=vnew;
fv.faces=fnew;
patch(fv,'FaceColor',       [0.8 0.8 1.0],  'EdgeColor',       'none',         'FaceLighting',    'gouraud',       'AmbientStrength', 0.15);
camlight('headlight');
material('dull');
axis('image');
view([0 0]);
set(gca,'visible','off')
figBody.Snapshot.Caption = sprintf('3D Bodyscan');
figBody.Snapshot.Height = '6in';
figBody.Snapshot.Width = '7in';
add(sec32,figBody);  % add the figure to section
add(ch3,sec32)


sec33 = Section; %new secion
sec33.Title = '3D Fu�scan';

para3DFussscanninfo.Style = {HAlign('justify')}; %mache blocksatz
add(sec33,para3DFussscanninfo) %add the paragraph to the section

%stl files in leftfoot rightfoot path
figure()
figFussL = mlreportgen.report.Figure(gcf);
%load the stl files within a subject folder
[v, f, n, c, stltitle] = stlread2(leftfoot);
%slim it, data reduction
[vnew, fnew]=patchslim(v, f);
V=vnew;
F=fnew;
NITER=100;%repeat the smoothing n times
[fvsmooth.vertices, fvsmooth.faces] = smoothMesh(V,F,NITER);
title ('3D Scan des linken Fu�es')
subplot(1,2,1)
patch(fvsmooth,'FaceColor',       [0.8 0.8 1.0],  'EdgeColor',       'none',         'FaceLighting',    'gouraud',       'AmbientStrength', 0.15);
camlight('headlight');
material('dull');
axis('image');
view([85 5]);
set(gca,'visible','off')
subplot(1,2,2)
patch(fvsmooth,'FaceColor',       [0.8 0.8 1.0],  'EdgeColor',       'none',         'FaceLighting',    'gouraud',       'AmbientStrength', 0.15);
camlight('headlight');
material('dull');
axis('image');
view([185 6]);
set(gca,'visible','off')

%additional work around

[row, col]=find( fvsmooth.vertices(:,3)<50);
[MaxL,IndexMaxL] = max(fvsmooth.vertices(:,1));
[MminL,IndexMinL] = min(fvsmooth.vertices([row],1));
fussl = MaxL;
hold on
h4 = plot3(fvsmooth.vertices(IndexMaxL,1),fvsmooth.vertices(IndexMaxL,2),fvsmooth.vertices(IndexMaxL,3), 'ro');

templegAB = strcat ('Fussl�nge=',(num2str(round(MaxL,1))), 'mm');
text = {templegAB};
leg = legend ([h4], text,  'interpreter', 'none','FontSize',10);
set (leg, 'Location', 'Best');
legend boxoff

figFussL.Snapshot.Caption = sprintf('3D Scan des linken Fu�es');
figFussL.Snapshot.Height = '6in';
figFussL.Snapshot.Width = '7in';
add(sec33,figFussL);  % add the figure to section


%jetzt rechts
figure()
figFussR = mlreportgen.report.Figure(gcf);
%load the stl files within a subject folder
[v, f, n, c, stltitle] = stlread2(rightfoot);
%slim it, data reduction
[vnew, fnew]=patchslim(v, f);
V=vnew;
F=fnew;
NITER=100;%repeat the smoothing n times
[fvsmooth.vertices, fvsmooth.faces] = smoothMesh(V,F,NITER);
title ('3D Scan des rechten Fu�es')
subplot(1,2,1)
patch(fvsmooth,'FaceColor',       [0.8 0.8 1.0],  'EdgeColor',       'none',         'FaceLighting',    'gouraud',       'AmbientStrength', 0.15);
camlight('headlight');
material('dull');
axis('image');
view([85 5]);
set(gca,'visible','off')
subplot(1,2,2)
patch(fvsmooth,'FaceColor',       [0.8 0.8 1.0],  'EdgeColor',       'none',         'FaceLighting',    'gouraud',       'AmbientStrength', 0.15);
camlight('headlight');
material('dull');
axis('image');
view([185 6]);
set(gca,'visible','off')

%additional work around

[row, col]=find( fvsmooth.vertices(:,3)<50);
[MaxL,IndexMaxL] = max(fvsmooth.vertices(:,1));
[MminL,IndexMinL] = min(fvsmooth.vertices([row],1));
fussl = MaxL;
hold on
h4 = plot3(fvsmooth.vertices(IndexMaxL,1),fvsmooth.vertices(IndexMaxL,2),fvsmooth.vertices(IndexMaxL,3), 'ro');

templegAB = strcat ('Fussl�nge=',(num2str(round(MaxL,1))), 'mm');
text = {templegAB}
leg = legend ([h4], text,  'interpreter', 'none','FontSize',10);
set (leg, 'Location', 'Best');
legend boxoff




figFussR.Snapshot.Caption = sprintf('3D Scan des rechten Fu�es');
figFussR.Snapshot.Height = '6in';
figFussR.Snapshot.Width = '7in';
add(sec33,figFussR);  % add the figure to section

add(ch3,sec33)
add(rpt,ch3);



ch4 = Chapter();
ch4.Title = sprintf('3D Bewegungsanalyse');
sec40 = Section; %new secion
sec40.Title = 'Was ist das?';

para3DBewegungInfo.Style = {HAlign('justify')}; %mache blocksatz
add(sec40,para3DBewegungInfo) %add the paragraph to the section

add(ch4,sec40)

sec411 = Section; %new secion
sec411.Title = 'Experimentelle Laufschuhbedingungen in dieser Studie';
add(ch4,sec411)
paraSCHUHINFO.Style = {HAlign('justify')}; %mache blocksatz
add(sec411,paraSCHUHINFO) %add the paragraph to the section
%bild der schuhe
figure()
figSchuh = Figure(gcf);
figSchuh.Snapshot.Caption = sprintf('Experimentelle Schuhbedingungen in der Studie.');
imshow ('C:\Users\maipa\Desktop\Rastergrafik_Schuhe.png')
figSchuh.Snapshot.Height = '2.5in';
figSchuh.Snapshot.Width = '4in';

add(sec411,figSchuh)


sec41 = Section; %new secion
sec41.Title = 'Externe Bodenreaktionskr�fte';
add(ch4,sec41)
paraGRF.Style = {HAlign('justify')}; %mache blocksatz
add(sec41,paraGRF) %add the paragraph to the section

figure()
figGRFZ = mlreportgen.report.Figure(gcf);
plot(DATA.GRF.ProbMeanCurvesGRF.Running_Shoe_A.Z(:,demoofsubjectrow)/9.81,'linewidth', 4 ,'LineStyle', (stlye{1, 1}), 'color', (farbe{1, 1}))
hold on
plot(DATA.GRF.ProbMeanCurvesGRF.Running_Shoe_B.Z(:,demoofsubjectrow)/9.81,'linewidth', 4 ,'LineStyle', (stlye{1, 2}), 'color', (farbe{1, 2}))
plot(DATA.GRF.ProbMeanCurvesGRF.Running_Shoe_C.Z(:,demoofsubjectrow)/9.81,'linewidth', 4 ,'LineStyle', (stlye{1, 3}), 'color', (farbe{1, 3}))
plot((mean(DATA.GRF.ProbMeanCurvesGRF.Running_Shoe_A.Z,2)/9.81),'linewidth', 1 ,'LineStyle', (stlye{1, 1}), 'color', (farbe{1, 1}))
plot((mean(DATA.GRF.ProbMeanCurvesGRF.Running_Shoe_B.Z,2)/9.81),'linewidth', 1 ,'LineStyle', (stlye{1,2 }), 'color', (farbe{1, 2}))
plot((mean(DATA.GRF.ProbMeanCurvesGRF.Running_Shoe_C.Z,2)/9.81),'linewidth', 1 ,'LineStyle', (stlye{1, 3}), 'color', (farbe{1, 3}))

set(gca,'Fontname','CMU Sans Serif')
set(gca, 'Fontsize', 12)
set(gca, 'linewidth', 2)
box off
leg = legend ({'Laufschuh A', 'Laufschuh B','Laufschuh C'}, 'interpreter', 'none','FontSize',16);
set (leg, 'Location', 'Best')
legend boxoff
xlim([1, 201]);
xlabel ('% der St�tzphase')
xticks([1  201/4 2*201/4 3*201/4 201])
xticklabels({'0','25','50','75', '100'})
ylabel ('vertikale Reaktionskraft im Verh�ltnis zum K�rpergewicht')
figGRFZ.Snapshot.Caption = sprintf('Senkrecht / Vertikale Bodenreaktionskraft im Verlauf der St�tzphase, angegeben im Vielfachen Ihres K�rpergewichts.');
figGRFZ.Snapshot.Height = Height;
figGRFZ.Snapshot.Width = Witdth;
add(sec41,figGRFZ);  % add the figure to section

figure()
figGRFX = mlreportgen.report.Figure(gcf);
plot(DATA.GRF.ProbMeanCurvesGRF.Running_Shoe_A.X(:,demoofsubjectrow)/9.81,'linewidth', 4 ,'LineStyle', (stlye{1, 1}), 'color', (farbe{1, 1}))
hold on
plot(DATA.GRF.ProbMeanCurvesGRF.Running_Shoe_B.X(:,demoofsubjectrow)/9.81,'linewidth', 4 ,'LineStyle', (stlye{1, 2}), 'color', (farbe{1, 2}))
plot(DATA.GRF.ProbMeanCurvesGRF.Running_Shoe_C.X(:,demoofsubjectrow)/9.81,'linewidth', 4 ,'LineStyle', (stlye{1, 3}), 'color', (farbe{1, 3}))
plot((mean(DATA.GRF.ProbMeanCurvesGRF.Running_Shoe_A.X,2)/9.81),'linewidth', 1 ,'LineStyle', (stlye{1, 1}), 'color', (farbe{1, 1}))
plot((mean(DATA.GRF.ProbMeanCurvesGRF.Running_Shoe_B.X,2)/9.81),'linewidth', 1 ,'LineStyle', (stlye{1,2 }), 'color', (farbe{1, 2}))
plot((mean(DATA.GRF.ProbMeanCurvesGRF.Running_Shoe_C.X,2)/9.81),'linewidth', 1 ,'LineStyle', (stlye{1, 3}), 'color', (farbe{1, 3}))

set(gca,'Fontname','CMU Sans Serif')
set(gca, 'Fontsize', 12)
set(gca, 'linewidth', 2)
box off
leg = legend ({'Laufschuh A', 'Laufschuh B','Laufschuh C'}, 'interpreter', 'none','FontSize',16);
set (leg, 'Location', 'Best')
legend boxoff
xlim([1, 201]);
xlabel ('% der St�tzphase')
xticks([1  201/4 2*201/4 3*201/4 201])
xticklabels({'0','25','50','75', '100'})
ylabel ('post/ ant Reaktionskraft im Verh�ltnis zum K�rpergewicht')
figGRFX.Snapshot.Caption = sprintf('Posterior / anterior Bodenreaktionskraft im Verlauf der St�tzphase, angegeben im Vielfachen Ihres K�rpergewichts.');
figGRFX.Snapshot.Height = Height;
figGRFX.Snapshot.Width = Witdth;
add(sec41,figGRFX);  % add the figure to section

figure()
figGRFY = mlreportgen.report.Figure(gcf);
plot(DATA.GRF.ProbMeanCurvesGRF.Running_Shoe_A.Y(:,demoofsubjectrow)/9.81,'linewidth', 4 ,'LineStyle', (stlye{1, 1}), 'color', (farbe{1, 1}))
hold on
plot(DATA.GRF.ProbMeanCurvesGRF.Running_Shoe_B.Y(:,demoofsubjectrow)/9.81,'linewidth', 4 ,'LineStyle', (stlye{1, 2}), 'color', (farbe{1, 2}))
plot(DATA.GRF.ProbMeanCurvesGRF.Running_Shoe_C.Y(:,demoofsubjectrow)/9.81,'linewidth', 4 ,'LineStyle', (stlye{1, 3}), 'color', (farbe{1, 3}))
plot((mean(DATA.GRF.ProbMeanCurvesGRF.Running_Shoe_A.Y,2)/9.81),'linewidth', 1 ,'LineStyle', (stlye{1, 1}), 'color', (farbe{1, 1}))
plot((mean(DATA.GRF.ProbMeanCurvesGRF.Running_Shoe_B.Y,2)/9.81),'linewidth', 1 ,'LineStyle', (stlye{1,2 }), 'color', (farbe{1, 2}))
plot((mean(DATA.GRF.ProbMeanCurvesGRF.Running_Shoe_C.Y,2)/9.81),'linewidth', 1 ,'LineStyle', (stlye{1, 3}), 'color', (farbe{1, 3}))

set(gca,'Fontname','CMU Sans Serif')
set(gca, 'Fontsize', 12)
set(gca, 'linewidth', 2)
xlim([1, 201]);
box off
leg = legend ({'Laufschuh A', 'Laufschuh B','Laufschuh C'}, 'interpreter', 'none','FontSize',16);
set (leg, 'Location', 'Best')
legend boxoff
xlabel ('% der St�tzphase')
xticks([1  201/4 2*201/4 3*201/4 201])
xticklabels({'0','25','50','75', '100'})
ylabel ('med./ lat. Reaktionskraft im Verh�ltnis zum K�rpergewicht')
figGRFY.Snapshot.Caption = sprintf('Medial / Laterale Bodenreaktionskraft im Verlauf der St�tzphase, angegeben im Vielfachen Ihres K�rpergewichts.');
figGRFY.Snapshot.Height = Height;
figGRFY.Snapshot.Width = Witdth;
add(sec41,figGRFY);  % add the figure to section

%%%%KINEMATIC
sec42 = Section; %new secion
sec42.Title = 'Gelenkskinematik';
add(ch4,sec42)
paraKINEMATIKinfo.Style = {HAlign('justify')}; %mache blocksatz
add(sec42,paraKINEMATIKinfo) %add the paragraph to the section

%%%%FUSSAUFATZ
figure()
figFussaufatzinfo = mlreportgen.report.Figure(gcf);
imshow ('C:\Users\maipa\Desktop\fussaufatz_small.png')
figFussaufatzinfo.Snapshot.Caption = sprintf('Illustration des Fussaufatzverhaltens bei Vor- und R�ckfussl�ufern');
figFussaufatzinfo.Snapshot.Height = '2in';
figFussaufatzinfo.Snapshot.Width = '3in';
add(sec42,figFussaufatzinfo);  % add the figure to section
mittelfussaufatz = num2str(round(mean(DATA.DISCRTE.DATA.ANGLES_RIGHT_ANKLE_Y_TD(demoofsubjectrow,[1:3])),0));
schuhA = convertCharsToStrings(num2str(round(mean(DATA.DISCRTE.DATA.ANGLES_RIGHT_ANKLE_Y_TD(demoofsubjectrow,[1])),0)));
SchuhB =  convertCharsToStrings(num2str(round(mean(DATA.DISCRTE.DATA.ANGLES_RIGHT_ANKLE_Y_TD(demoofsubjectrow,[2])),0)));
SchuhC =  convertCharsToStrings (num2str(round(mean(DATA.DISCRTE.DATA.ANGLES_RIGHT_ANKLE_Y_TD(demoofsubjectrow,[3])),0)));


if round(mean(DATA.DISCRTE.DATA.ANGLES_RIGHT_ANKLE_Y_TD(demoofsubjectrow,[1:3])),0) <=-5
    laufertype = 'R�ckfussl�ufer';
else
    laufertype = 'Vorfussl�ufer';
end



paraFussaufatz = Paragraph([strcat('Basiert auf dem Fussaufatzverhalten kann man l�ufer klassifizieren. Ihr Fussaufatz im mittel betrug', {' '},convertCharsToStrings(mittelfussaufatz),'�', {' '},'sind sind also eher ein', {' '}, convertCharsToStrings(laufertype),'.',{' '},'Im Laufschuh A betrug ihr Fussaufatzwinkel',schuhA,{'� '},', im Schuh B',{' '},SchuhB, {'� '}, 'und im Schuh C',{' '},SchuhC, {' �.'} , 'Ihr Fussaufatzverhalten hat sich somit durch die Laufschuhe etwas ver�ndert.')]);
paraFussaufatz.Style = {HAlign('justify')}; %mache blocksatz
add(sec42,paraFussaufatz) %add the paragraph to the section


personalversion = [DATA.AbisCDiscrete.DATA.Angu_Vel_Ankle_X_MIN((demoofsubjectrow),1), DATA.AbisCDiscrete.DATA.Angu_Vel_Ankle_X_MIN((demoofsubjectrow),2), DATA.AbisCDiscrete.DATA.Angu_Vel_Ankle_X_MIN((demoofsubjectrow),3)];
[row, col]=max (personalversion);
if col ==2
    besti = convertCharsToStrings('Laufschuh B');
elseif col ==1
    besti = convertCharsToStrings('Laufschuh A');
elseif col ==3
    besti = convertCharsToStrings('Laufschuh C');
end
paraEverVelcoity = Paragraph([strcat('Die maximale Eversionsgeschwindigkeit des Sprunggelenks gibt an, wie schnell die Eversion des Sprungelenks stattgefunden hat. Dieser Parameter wird ebenfalls im Zusammenhang mit laufbedingten �berbelastungsverletzungen genannt. Die Eversionsgeschwindigkeit (negativer wert in �/s) und die Inversionsgeschwindigkeit (postiver wert in �/s) k�nnen auch durch verschiedene Schuhmodikationen beeinflusst werden. Ein Schuh der dabei die Eversionsgeschwindigkeit verringert (weniger hohe negative Werte) kann somit unter umst�nden das Verletzungsrisiko minimieren.',{' '},besti,{' '} , 'verringert bei Ihnen die Eversionsgeschwindigkeit.')]);
paraEverVelcoity.Style = {HAlign('justify')}; %mache blocksatz
add(sec42,paraEverVelcoity) %add the paragraph to the section

figure()
figeversionvel= mlreportgen.report.Figure(gcf);
vs = violinplot(DATA.AbisCDiscrete.DATA.Angu_Vel_Ankle_X_MIN);
ylabel ('max. Eversionswinkelgeschwindigkeit Sprunggelenk �/s')
set(gca,'Fontname','CMU Sans Serif')
set(gca, 'FontSize', 20);
set(gca, 'linewidth', 2)
set(gcf,'color','w');
set(gca, 'FontSize', 12);
box off
hold on
xticks([1 2 3])
xticklabels({'Schuh A','Schuh B', 'Schuh C'})
scatter (1, (DATA.AbisCDiscrete.DATA.Angu_Vel_Ankle_X_MIN((demoofsubjectrow),1)), 'filled', 'r')
scatter (2, (DATA.AbisCDiscrete.DATA.Angu_Vel_Ankle_X_MIN((demoofsubjectrow),2)), 'filled', 'r')
scatter (3, (DATA.AbisCDiscrete.DATA.Angu_Vel_Ankle_X_MIN((demoofsubjectrow),3)), 'filled', 'r')
x = [1, 2, 3];
y = [(DATA.AbisCDiscrete.DATA.Angu_Vel_Ankle_X_MIN((demoofsubjectrow),1)), (DATA.AbisCDiscrete.DATA.Angu_Vel_Ankle_X_MIN((demoofsubjectrow),2)), (DATA.AbisCDiscrete.DATA.Angu_Vel_Ankle_X_MIN((demoofsubjectrow),3))];
plot(x,y, 'linewidth', 1.5, 'color', 'r')
figeversionvel.Snapshot.Caption = sprintf('Ihre Maximale Sprunggelenks Eversionsgeschwindigkeit (rot), im Vergliech zu den anderen Teilnehmern.');
figeversionvel.Snapshot.Height = '3in';
figeversionvel.Snapshot.Width = '4in';
add(sec42,figeversionvel);  % add the figure to section
paraEverWinkel = Paragraph([strcat('Hohe Eversionswinkel am Sprunggelenks werden ebenfalls oft in Verbindung mit Verletzungen im laufsport erw�hnt. Oftmals wird dies auch als �berpronation bezeichnet. Es sei an dieser Stelle jedoch zu erw�hnen das die Studienlage hierzu sehr gegens�tzliche Ergebnisse pr�sentiert. �berpronation beudeutet dem zufolge nicht gleichzeitig ein gro�es Risiko.')]);
paraEverWinkel.Style = {HAlign('justify')}; %mache blocksatz
add(sec42,paraEverWinkel) %add the paragraph to the section


figure()
figANKLEX = mlreportgen.report.Figure(gcf);
plot(DATA.KandK.ProbMeanCurves.Running_Shoe_A.ANGLES.KNEE.X(:,demoofsubjectrow),'linewidth', 4 ,'LineStyle', (stlye{1, 1}), 'color', (farbe{1, 1}))
hold on
plot(DATA.KandK.ProbMeanCurves.Running_Shoe_B.ANGLES.KNEE.X(:,demoofsubjectrow),'linewidth', 4 ,'LineStyle', (stlye{1, 2}), 'color', (farbe{1, 2}))
plot(DATA.KandK.ProbMeanCurves.Running_Shoe_C.ANGLES.KNEE.X(:,demoofsubjectrow),'linewidth', 4 ,'LineStyle', (stlye{1, 3}), 'color', (farbe{1, 3}))

set(gca,'Fontname','CMU Sans Serif')
set(gca, 'Fontsize', 12)
set(gca, 'linewidth', 2)
box off
leg = legend ({'Laufschuh A', 'Laufschuh B','Laufschuh C'}, 'interpreter', 'none','FontSize',16);
set (leg, 'Location', 'Best')
legend boxoff
xlim([1, 201]);
xlabel ('% der St�tzphase')
xticks([1  201/4 2*201/4 3*201/4 201])
xticklabels({'0','25','50','75', '100'})
ylabel ('Sprunggelenkswinkel Frontalebene [�]')
figANKLEX.Snapshot.Caption = sprintf('Sprunggelenkswinkel in der Fronalebene (Eversion/ Inversion)');
figANKLEX.Snapshot.Height = Height;
figANKLEX.Snapshot.Width = Witdth;
add(sec42,figANKLEX);  % add the figure to section

%jettz einfach alle anderen Gelenkswinkel

%h�fte
figure()
figHipAng = mlreportgen.report.Figure(gcf);
schriftgr= 10;

subplot(3,1,1)
plot(DATA.KandK.ProbMeanCurves.Running_Shoe_A.ANGLES.HIP.X([20:181],demoofsubjectrow),'linewidth', 4 ,'LineStyle', (stlye{1, 1}), 'color', (farbe{1, 1}))
hold on
plot(DATA.KandK.ProbMeanCurves.Running_Shoe_B.ANGLES.HIP.X([20:181],demoofsubjectrow),'linewidth', 4 ,'LineStyle', (stlye{1, 2}), 'color', (farbe{1, 2}))
plot(DATA.KandK.ProbMeanCurves.Running_Shoe_C.ANGLES.HIP.X([20:181],demoofsubjectrow),'linewidth', 4 ,'LineStyle', (stlye{1, 3}), 'color', (farbe{1, 3}))

plot(((mean(DATA.KandK.ProbMeanCurves.Running_Shoe_A.ANGLES.HIP.X([20:181],:),2))),'linewidth', 1 ,'LineStyle', (stlye{1, 1}), 'color', (farbe{1, 1}))
plot(((mean(DATA.KandK.ProbMeanCurves.Running_Shoe_B.ANGLES.HIP.X([20:181],:),2))),'linewidth', 1 ,'LineStyle', (stlye{1,2 }), 'color', (farbe{1, 2}))
plot(((mean(DATA.KandK.ProbMeanCurves.Running_Shoe_C.ANGLES.HIP.X([20:181],:),2))),'linewidth', 1 ,'LineStyle', (stlye{1, 3}), 'color', (farbe{1, 3}))



ylabel ('Frontal [�]')
set(gca,'Fontname','CMU Sans Serif')
set(gca, 'FontSize', schriftgr);
set(gca, 'linewidth', 2)
set(gcf,'color','w');
set(gca, 'FontSize', schriftgr);
box off
set(gca,'xtick',[]);
set(gca,'xcolor',[1 1 1])
xlim([1, 161]);
subplot(3,1,2)

plot(DATA.KandK.ProbMeanCurves.Running_Shoe_A.ANGLES.HIP.Y([20:181],demoofsubjectrow),'linewidth', 4 ,'LineStyle', (stlye{1, 1}), 'color', (farbe{1, 1}))
hold on
plot(DATA.KandK.ProbMeanCurves.Running_Shoe_B.ANGLES.HIP.Y([20:181],demoofsubjectrow),'linewidth', 4 ,'LineStyle', (stlye{1, 2}), 'color', (farbe{1, 2}))
plot(DATA.KandK.ProbMeanCurves.Running_Shoe_C.ANGLES.HIP.Y([20:181],demoofsubjectrow),'linewidth', 4 ,'LineStyle', (stlye{1, 3}), 'color', (farbe{1, 3}))

plot(((mean(DATA.KandK.ProbMeanCurves.Running_Shoe_A.ANGLES.HIP.Y([20:181],:),2))),'linewidth', 1 ,'LineStyle', (stlye{1, 1}), 'color', (farbe{1, 1}))
plot(((mean(DATA.KandK.ProbMeanCurves.Running_Shoe_B.ANGLES.HIP.Y([20:181],:),2))),'linewidth', 1 ,'LineStyle', (stlye{1,2 }), 'color', (farbe{1, 2}))
plot(((mean(DATA.KandK.ProbMeanCurves.Running_Shoe_C.ANGLES.HIP.Y([20:181],:),2))),'linewidth', 1 ,'LineStyle', (stlye{1, 3}), 'color', (farbe{1, 3}))



set(gca,'Fontname','CMU Sans Serif')
set(gca, 'FontSize', schriftgr);
set(gca, 'linewidth', 2)
set(gcf,'color','w');
set(gca, 'FontSize', schriftgr);
box off
set(gca,'xtick',[]);
set(gca,'xcolor',[1 1 1])
xlim([1, 161]);
ylabel ('Sagittal [�]')
subplot(3,1,3)
set(gca,'xcolor',[0 0 0])
plot(DATA.KandK.ProbMeanCurves.Running_Shoe_A.ANGLES.HIP.Z([20:181],demoofsubjectrow),'linewidth', 4 ,'LineStyle', (stlye{1, 1}), 'color', (farbe{1, 1}))
hold on
plot(DATA.KandK.ProbMeanCurves.Running_Shoe_B.ANGLES.HIP.Z([20:181],demoofsubjectrow),'linewidth', 4 ,'LineStyle', (stlye{1, 2}), 'color', (farbe{1, 2}))
plot(DATA.KandK.ProbMeanCurves.Running_Shoe_C.ANGLES.HIP.Z([20:181],demoofsubjectrow),'linewidth', 4 ,'LineStyle', (stlye{1, 3}), 'color', (farbe{1, 3}))
plot(((mean(DATA.KandK.ProbMeanCurves.Running_Shoe_A.ANGLES.HIP.Z([20:181],:),2))),'linewidth', 1 ,'LineStyle', (stlye{1, 1}), 'color', (farbe{1, 1}))
plot(((mean(DATA.KandK.ProbMeanCurves.Running_Shoe_B.ANGLES.HIP.Z([20:181],:),2))),'linewidth', 1 ,'LineStyle', (stlye{1,2 }), 'color', (farbe{1, 2}))
plot(((mean(DATA.KandK.ProbMeanCurves.Running_Shoe_C.ANGLES.HIP.Z([20:181],:),2))),'linewidth', 1 ,'LineStyle', (stlye{1, 3}), 'color', (farbe{1, 3}))



set(gca,'Fontname','CMU Sans Serif')
set(gca, 'FontSize', schriftgr);
set(gca, 'linewidth', 2)
set(gcf,'color','w');
set(gca, 'FontSize', schriftgr);
xlabel ('% der St�tzphase')
xticks([1 181/2-181/4-20 181/2-20 181/2+(181/4)-20 181-20])
xticklabels({'0','25','50','75', '100'})
box off
xlim([1, 161]);
ylabel ('Transversal [�]')

figHipAng.Snapshot.Caption =  sprintf('Gelenkswinkel an der H�fte in allen 3 Raumebenen, d�nnen Linien zeigen dabei den Gruppenmittelwert aller Probanden.');
figHipAng.Snapshot.Height = '5in';
figHipang.Snapshot.Width = '6in';

add(sec42,figHipAng);  % add the figure to section


%knee mom
figure()
figKneeAng = mlreportgen.report.Figure(gcf);


subplot(3,1,1)
plot(DATA.KandK.ProbMeanCurves.Running_Shoe_A.ANGLES.KNEE.X([20:181],demoofsubjectrow),'linewidth', 4 ,'LineStyle', (stlye{1, 1}), 'color', (farbe{1, 1}))
hold on
plot(DATA.KandK.ProbMeanCurves.Running_Shoe_B.ANGLES.KNEE.X([20:181],demoofsubjectrow),'linewidth', 4 ,'LineStyle', (stlye{1, 2}), 'color', (farbe{1, 2}))
plot(DATA.KandK.ProbMeanCurves.Running_Shoe_C.ANGLES.KNEE.X([20:181],demoofsubjectrow),'linewidth', 4 ,'LineStyle', (stlye{1, 3}), 'color', (farbe{1, 3}))

plot(((mean(DATA.KandK.ProbMeanCurves.Running_Shoe_A.ANGLES.KNEE.X([20:181],:),2))),'linewidth', 1 ,'LineStyle', (stlye{1, 1}), 'color', (farbe{1, 1}))
plot(((mean(DATA.KandK.ProbMeanCurves.Running_Shoe_B.ANGLES.KNEE.X([20:181],:),2))),'linewidth', 1 ,'LineStyle', (stlye{1,2 }), 'color', (farbe{1, 2}))
plot(((mean(DATA.KandK.ProbMeanCurves.Running_Shoe_C.ANGLES.KNEE.X([20:181],:),2))),'linewidth', 1 ,'LineStyle', (stlye{1, 3}), 'color', (farbe{1, 3}))


ylabel ('Frontal [�]')
set(gca,'Fontname','CMU Sans Serif')
set(gca, 'FontSize', schriftgr);
set(gca, 'linewidth', 2)
set(gcf,'color','w');
set(gca, 'FontSize', schriftgr);
box off
set(gca,'xtick',[]);
set(gca,'xcolor',[1 1 1])
xlim([1, 161]);
subplot(3,1,2)

plot(DATA.KandK.ProbMeanCurves.Running_Shoe_A.ANGLES.KNEE.Y([20:181],demoofsubjectrow),'linewidth', 4 ,'LineStyle', (stlye{1, 1}), 'color', (farbe{1, 1}))
hold on
plot(DATA.KandK.ProbMeanCurves.Running_Shoe_B.ANGLES.KNEE.Y([20:181],demoofsubjectrow),'linewidth', 4 ,'LineStyle', (stlye{1, 2}), 'color', (farbe{1, 2}))
plot(DATA.KandK.ProbMeanCurves.Running_Shoe_C.ANGLES.KNEE.Y([20:181],demoofsubjectrow),'linewidth', 4 ,'LineStyle', (stlye{1, 3}), 'color', (farbe{1, 3}))
plot(((mean(DATA.KandK.ProbMeanCurves.Running_Shoe_A.ANGLES.KNEE.Y([20:181],:),2))),'linewidth', 1 ,'LineStyle', (stlye{1, 1}), 'color', (farbe{1, 1}))
plot(((mean(DATA.KandK.ProbMeanCurves.Running_Shoe_B.ANGLES.KNEE.Y([20:181],:),2))),'linewidth', 1 ,'LineStyle', (stlye{1,2 }), 'color', (farbe{1, 2}))
plot(((mean(DATA.KandK.ProbMeanCurves.Running_Shoe_C.ANGLES.KNEE.Y([20:181],:),2))),'linewidth', 1 ,'LineStyle', (stlye{1, 3}), 'color', (farbe{1, 3}))


set(gca,'Fontname','CMU Sans Serif')
set(gca, 'FontSize', schriftgr);
set(gca, 'linewidth', 2)
set(gcf,'color','w');
set(gca, 'FontSize', schriftgr);
box off
set(gca,'xtick',[]);
set(gca,'xcolor',[1 1 1])
xlim([1, 161]);
ylabel ('Sagittal [�]')
subplot(3,1,3)
set(gca,'xcolor',[0 0 0])
plot(DATA.KandK.ProbMeanCurves.Running_Shoe_A.ANGLES.KNEE.Z([20:181],demoofsubjectrow),'linewidth', 4 ,'LineStyle', (stlye{1, 1}), 'color', (farbe{1, 1}))
hold on
plot(DATA.KandK.ProbMeanCurves.Running_Shoe_B.ANGLES.KNEE.Z([20:181],demoofsubjectrow),'linewidth', 4 ,'LineStyle', (stlye{1, 2}), 'color', (farbe{1, 2}))
plot(DATA.KandK.ProbMeanCurves.Running_Shoe_C.ANGLES.KNEE.Z([20:181],demoofsubjectrow),'linewidth', 4 ,'LineStyle', (stlye{1, 3}), 'color', (farbe{1, 3}))
plot(((mean(DATA.KandK.ProbMeanCurves.Running_Shoe_A.ANGLES.KNEE.Z([20:181],:),2))),'linewidth', 1 ,'LineStyle', (stlye{1, 1}), 'color', (farbe{1, 1}))
plot(((mean(DATA.KandK.ProbMeanCurves.Running_Shoe_B.ANGLES.KNEE.Z([20:181],:),2))),'linewidth', 1 ,'LineStyle', (stlye{1,2 }), 'color', (farbe{1, 2}))
plot(((mean(DATA.KandK.ProbMeanCurves.Running_Shoe_C.ANGLES.KNEE.Z([20:181],:),2))),'linewidth', 1 ,'LineStyle', (stlye{1, 3}), 'color', (farbe{1, 3}))



set(gca,'Fontname','CMU Sans Serif')
set(gca, 'FontSize', schriftgr);
set(gca, 'linewidth', 2)
set(gcf,'color','w');
set(gca, 'FontSize', schriftgr);
xlabel ('% der St�tzphase')
xticks([1 181/2-181/4-20 181/2-20 181/2+(181/4)-20 181-20])
xticklabels({'0','25','50','75', '100'})
box off
xlim([1, 161]);
ylabel ('Transversal [�]')

figKneeAng.Snapshot.Caption =  sprintf('Gelenkswinkel am Knie in allen 3 Raumebenen, d�nnen Linien zeigen dabei den Gruppenmittelwert aller Probanden.');
figKneeAng.Snapshot.Height = '5in';
figKneeAng.Snapshot.Width = '6in';

add(sec42,figKneeAng);  % add the figure to section


%knee mom
figure()
figAnkleAng = mlreportgen.report.Figure(gcf);


subplot(3,1,1)
plot(DATA.KandK.ProbMeanCurves.Running_Shoe_A.ANGLES.ANKLE.X([20:181],demoofsubjectrow),'linewidth', 4 ,'LineStyle', (stlye{1, 1}), 'color', (farbe{1, 1}))
hold on
plot(DATA.KandK.ProbMeanCurves.Running_Shoe_B.ANGLES.ANKLE.X([20:181],demoofsubjectrow),'linewidth', 4 ,'LineStyle', (stlye{1, 2}), 'color', (farbe{1, 2}))
plot(DATA.KandK.ProbMeanCurves.Running_Shoe_C.ANGLES.ANKLE.X([20:181],demoofsubjectrow),'linewidth', 4 ,'LineStyle', (stlye{1, 3}), 'color', (farbe{1, 3}))
plot(((mean(DATA.KandK.ProbMeanCurves.Running_Shoe_A.ANGLES.ANKLE.X([20:181],:),2))),'linewidth', 1 ,'LineStyle', (stlye{1, 1}), 'color', (farbe{1, 1}))
plot(((mean(DATA.KandK.ProbMeanCurves.Running_Shoe_B.ANGLES.ANKLE.X([20:181],:),2))),'linewidth', 1 ,'LineStyle', (stlye{1,2 }), 'color', (farbe{1, 2}))
plot(((mean(DATA.KandK.ProbMeanCurves.Running_Shoe_C.ANGLES.ANKLE.X([20:181],:),2))),'linewidth', 1 ,'LineStyle', (stlye{1, 3}), 'color', (farbe{1, 3}))



ylabel ('Frontal [�]')
set(gca,'Fontname','CMU Sans Serif')
set(gca, 'FontSize', schriftgr);
set(gca, 'linewidth', 2)
set(gcf,'color','w');
set(gca, 'FontSize', schriftgr);
box off
set(gca,'xtick',[]);
set(gca,'xcolor',[1 1 1])
xlim([1, 161]);
subplot(3,1,2)

plot(DATA.KandK.ProbMeanCurves.Running_Shoe_A.ANGLES.ANKLE.Y([20:181],demoofsubjectrow),'linewidth', 4 ,'LineStyle', (stlye{1, 1}), 'color', (farbe{1, 1}))
hold on
plot(DATA.KandK.ProbMeanCurves.Running_Shoe_B.ANGLES.ANKLE.Y([20:181],demoofsubjectrow),'linewidth', 4 ,'LineStyle', (stlye{1, 2}), 'color', (farbe{1, 2}))
plot(DATA.KandK.ProbMeanCurves.Running_Shoe_C.ANGLES.ANKLE.Y([20:181],demoofsubjectrow),'linewidth', 4 ,'LineStyle', (stlye{1, 3}), 'color', (farbe{1, 3}))
plot(((mean(DATA.KandK.ProbMeanCurves.Running_Shoe_A.ANGLES.ANKLE.Y([20:181],:),2))),'linewidth', 1 ,'LineStyle', (stlye{1, 1}), 'color', (farbe{1, 1}))
plot(((mean(DATA.KandK.ProbMeanCurves.Running_Shoe_B.ANGLES.ANKLE.Y([20:181],:),2))),'linewidth', 1 ,'LineStyle', (stlye{1,2 }), 'color', (farbe{1, 2}))
plot(((mean(DATA.KandK.ProbMeanCurves.Running_Shoe_C.ANGLES.ANKLE.Y([20:181],:),2))),'linewidth', 1 ,'LineStyle', (stlye{1, 3}), 'color', (farbe{1, 3}))


set(gca,'Fontname','CMU Sans Serif')
set(gca, 'FontSize', schriftgr);
set(gca, 'linewidth', 2)
set(gcf,'color','w');
set(gca, 'FontSize', schriftgr);
box off
set(gca,'xtick',[]);
set(gca,'xcolor',[1 1 1])
xlim([1, 161]);
ylabel ('Sagittal [�]')
subplot(3,1,3)
set(gca,'xcolor',[0 0 0])
plot(DATA.KandK.ProbMeanCurves.Running_Shoe_A.ANGLES.ANKLE.Z([20:181],demoofsubjectrow),'linewidth', 4 ,'LineStyle', (stlye{1, 1}), 'color', (farbe{1, 1}))
hold on
plot(DATA.KandK.ProbMeanCurves.Running_Shoe_B.ANGLES.ANKLE.Z([20:181],demoofsubjectrow),'linewidth', 4 ,'LineStyle', (stlye{1, 2}), 'color', (farbe{1, 2}))
plot(DATA.KandK.ProbMeanCurves.Running_Shoe_C.ANGLES.ANKLE.Z([20:181],demoofsubjectrow),'linewidth', 4 ,'LineStyle', (stlye{1, 3}), 'color', (farbe{1, 3}))
plot(((mean(DATA.KandK.ProbMeanCurves.Running_Shoe_A.ANGLES.ANKLE.Z([20:181],:),2))),'linewidth', 1 ,'LineStyle', (stlye{1, 1}), 'color', (farbe{1, 1}))
plot(((mean(DATA.KandK.ProbMeanCurves.Running_Shoe_B.ANGLES.ANKLE.Z([20:181],:),2))),'linewidth', 1 ,'LineStyle', (stlye{1,2 }), 'color', (farbe{1, 2}))
plot(((mean(DATA.KandK.ProbMeanCurves.Running_Shoe_C.ANGLES.ANKLE.Z([20:181],:),2))),'linewidth', 1 ,'LineStyle', (stlye{1, 3}), 'color', (farbe{1, 3}))



set(gca,'Fontname','CMU Sans Serif')
set(gca, 'FontSize', schriftgr);
set(gca, 'linewidth', 2)
set(gcf,'color','w');
set(gca, 'FontSize', schriftgr);
xlabel ('% der St�tzphase')
xticks([1 181/2-181/4-20 181/2-20 181/2+(181/4)-20 181-20])
xticklabels({'0','25','50','75', '100'})
box off
xlim([1, 161]);
ylabel ('Transversal [�]')

figAnkleAng.Snapshot.Caption =  sprintf('Gelenkswinkel am Sprunggelenk in allen 3 Raumebenen, d�nnen Linien zeigen dabei den Gruppenmittelwert aller Probanden.');
figAnkleAng.Snapshot.Height = '5in';
figAnkleAng.Snapshot.Width = '6in';

add(sec42,figAnkleAng);  % add the figure to section



%%%% end of kinematics

br = PageBreak();
add(rpt,br);
%KINETIC
sec43 = Section; %new secion
sec43.Title = 'Gelenkskinetik';
add(ch4,sec43)
paraKINETIKinfo.Style = {HAlign('justify')}; %mache blocksatz
add(sec43,paraKINETIKinfo) %add the paragraph to the section



figure()
figKAMinfo = mlreportgen.report.Figure(gcf);
imshow ('C:\Users\maipa\Desktop\KAM.png')
figKAMinfo.Snapshot.Caption = sprintf('Kleine Ursache, Gro�e Wirkung: Schematische Darstellung, wie Drehmomente am Knie ver�ndert werden k�nnen. Durch ein umorientieren der externen Kr�fte (welche auf den Boden aufgebracht werden), kann der Hebelarm bespw. vom Kniegelenk verkleiner werden. Diese f�hrt trotz noch gleiche Kraft (vgl. Bild links und Bild rechts) zu einem kleinen Kniedrehmoment. Solche umorientierungen der Kraft k�nnen u.a. durch verscheidene St�tzelemente in Laufschuhen erreicht werden.');
figKAMinfo.Snapshot.Height = '3in';
figKAMinfo.Snapshot.Width = '5in';
add(sec43,figKAMinfo);  % add the figure to section



figure()
figKAM = mlreportgen.report.Figure(gcf);
plot(DATA.KandK.ProbMeanCurves.Running_Shoe_A.MOMENTS.KNEE.X(:,demoofsubjectrow),'linewidth', 4 ,'LineStyle', (stlye{1, 1}), 'color', (farbe{1, 1}))
hold on
plot(DATA.KandK.ProbMeanCurves.Running_Shoe_B.MOMENTS.KNEE.X(:,demoofsubjectrow),'linewidth', 4 ,'LineStyle', (stlye{1, 2}), 'color', (farbe{1, 2}))
plot(DATA.KandK.ProbMeanCurves.Running_Shoe_C.MOMENTS.KNEE.X(:,demoofsubjectrow),'linewidth', 4 ,'LineStyle', (stlye{1, 3}), 'color', (farbe{1, 3}))
dirtymatrix =[DATA.KandK.ProbMeanCurves.Running_Shoe_A.MOMENTS.KNEE.X(:,demoofsubjectrow), DATA.KandK.ProbMeanCurves.Running_Shoe_B.MOMENTS.KNEE.X(:,demoofsubjectrow), DATA.KandK.ProbMeanCurves.Running_Shoe_C.MOMENTS.KNEE.X(:,demoofsubjectrow)];
%schneide dirty matrix aus macht alles robuster
dirtymatrix=(dirtymatrix(20:180,:));
[M,I] = min(dirtymatrix);
[M,Indexunsed] = min(M);

[Mmax,Imax] = max(dirtymatrix);
[Mmax,Indexunsedmax] = max(Mmax);


grenzeny= ylim;
p1 = patch('vertices', [0, grenzeny(1,1); 0, grenzeny(1,2); 20,grenzeny(1,2) ; 20, grenzeny(1,1)], ...
    'faces', [1, 2, 3, 4], ...
    'FaceColor', 'k', ...
    'FaceAlpha', 0.5, 'LineStyle', 'none');
p2 = patch('vertices', [201-20, grenzeny(1,1); 201-20, grenzeny(1,2); 201,grenzeny(1,2) ; 201, grenzeny(1,1)], ...
    'faces', [1, 2, 3, 4], ...
    'FaceColor', 'k', ...
    'FaceAlpha', 0.5, 'LineStyle', 'none');
scatter (I(1,Indexunsed)+20,M, 100,'o', 'filled',  'MarkerFaceColor',[255 0 0]/255)
scatter (Imax(1,Indexunsedmax)+20,Mmax, 100,'o', 'filled',  'MarkerFaceColor',[0 128 0]/255)
set(gca,'Fontname','CMU Sans Serif')
set(gca, 'Fontsize', 12)
set(gca, 'linewidth', 2)
box off
leg = legend ({'Laufschuh A', 'Laufschuh B','Laufschuh C'}, 'interpreter', 'none','FontSize',16);
set (leg, 'Location', 'Best')
legend boxoff
xlim([1, 201]);
xlabel ('% der St�tzphase')
xticks([1  201/4 2*201/4 3*201/4 201])
xticklabels({'0','25','50','75', '100'})
ylabel ('Knie Abductionsmoment [Newtonmeter pro kg]')
figKAM.Snapshot.Caption = sprintf('Ihre Knieadduktionsdrehmomente in den drei unterschiedlichen Laufschuhen w�hrend des Bodenkontakts mit dem rechten Bein. Der rote Punkt symbolsiert dabei die Schuhbedingung f�r welche sich Ihr Kniedrehmoment vergr��ert hat (mehr negative). Der gr�ne Punkt zeigt f�r welche Schuhbedingung sich Ihr Knieabduktionsdrehmoment verkleinert hat.');
figKAM.Snapshot.Height = Height;
figKAM.Snapshot.Width = Witdth;
add(sec43,figKAM);  % add the figure to section

if Indexunsed==3
    schuhe = 'vergr��ert mit einem lateral'
elseif Indexunsed==1
    schuhe = 'vergr��ert mit einem neutral'
elseif Indexunsed==2
    schuhe = 'vergr��ert mit einem medial'
end

if Indexunsedmax==3
    schuhebesser = convertCharsToStrings('Schuh C')
elseif Indexunsedmax==1
    schuhebesser = convertCharsToStrings('Schuh A')
elseif Indexunsedmax==2
    schuhebessermax = convertCharsToStrings('Schuh B')
end

% paraZehenWertung = Paragraph([(strcat('Ihre Zehenkraft im Vergleich zu den anderen',{' '},moderw,{' '}, 'ist', {' '},convertCharsToStrings(temptext), {' '},'als der Gruppenmittelwert.',{' '}, zusatztext))]);



paraKINETIKKAMinfopersonal = Paragraph([(strcat('Die Auswertung zeigt, das sich Ihr Knieabduktionsmoment', convertCharsToStrings(schuhe), {' '} ,'gest�tzten Schuh.', {' '}, schuhebesser, 'w�re also im Bezug auf diesen Verletzungsparameter besser f�r Sie geeignet. Jedoch m�chten wir an dieser Stellen nochmals auf die kompl�zit�t von �berbelastungsverletzungen hinweissen und auf die multifaktoriali�t von Verletzungsmechanismen verweisen.'))]);

paraKINETIKKAMinfopersonal.Style = {HAlign('justify')}; %mache blocksatz
add(sec43,paraKINETIKKAMinfopersonal) %add the paragraph to the section

%jetzt einfach noch die anderen Momente damit die was zu sehen haben

%h�fte X momentf
figure()
figHipMom = mlreportgen.report.Figure(gcf);
schriftgr= 10;

subplot(3,1,1)
plot(DATA.KandK.ProbMeanCurves.Running_Shoe_A.MOMENTS.HIP.X([20:181],demoofsubjectrow),'linewidth', 4 ,'LineStyle', (stlye{1, 1}), 'color', (farbe{1, 1}))
hold on
plot(DATA.KandK.ProbMeanCurves.Running_Shoe_B.MOMENTS.HIP.X([20:181],demoofsubjectrow),'linewidth', 4 ,'LineStyle', (stlye{1, 2}), 'color', (farbe{1, 2}))
plot(DATA.KandK.ProbMeanCurves.Running_Shoe_C.MOMENTS.HIP.X([20:181],demoofsubjectrow),'linewidth', 4 ,'LineStyle', (stlye{1, 3}), 'color', (farbe{1, 3}))

plot(((mean(DATA.KandK.ProbMeanCurves.Running_Shoe_A.MOMENTS.HIP.X([20:181],:),2))),'linewidth', 1 ,'LineStyle', (stlye{1, 1}), 'color', (farbe{1, 1}))
plot(((mean(DATA.KandK.ProbMeanCurves.Running_Shoe_B.MOMENTS.HIP.X([20:181],:),2))),'linewidth', 1 ,'LineStyle', (stlye{1,2 }), 'color', (farbe{1, 2}))
plot(((mean(DATA.KandK.ProbMeanCurves.Running_Shoe_C.MOMENTS.HIP.X([20:181],:),2))),'linewidth', 1 ,'LineStyle', (stlye{1, 3}), 'color', (farbe{1, 3}))



ylabel ('Frontal [Nm/kg]')
set(gca,'Fontname','CMU Sans Serif')
set(gca, 'FontSize', schriftgr);
set(gca, 'linewidth', 2)
set(gcf,'color','w');
set(gca, 'FontSize', schriftgr);
box off
set(gca,'xtick',[]);
set(gca,'xcolor',[1 1 1])
xlim([1, 161]);
subplot(3,1,2)

plot(DATA.KandK.ProbMeanCurves.Running_Shoe_A.MOMENTS.HIP.Y([20:181],demoofsubjectrow),'linewidth', 4 ,'LineStyle', (stlye{1, 1}), 'color', (farbe{1, 1}))
hold on
plot(DATA.KandK.ProbMeanCurves.Running_Shoe_B.MOMENTS.HIP.Y([20:181],demoofsubjectrow),'linewidth', 4 ,'LineStyle', (stlye{1, 2}), 'color', (farbe{1, 2}))
plot(DATA.KandK.ProbMeanCurves.Running_Shoe_C.MOMENTS.HIP.Y([20:181],demoofsubjectrow),'linewidth', 4 ,'LineStyle', (stlye{1, 3}), 'color', (farbe{1, 3}))
plot(((mean(DATA.KandK.ProbMeanCurves.Running_Shoe_A.MOMENTS.HIP.Y([20:181],:),2))),'linewidth', 1 ,'LineStyle', (stlye{1, 1}), 'color', (farbe{1, 1}))
plot(((mean(DATA.KandK.ProbMeanCurves.Running_Shoe_B.MOMENTS.HIP.Y([20:181],:),2))),'linewidth', 1 ,'LineStyle', (stlye{1,2 }), 'color', (farbe{1, 2}))
plot(((mean(DATA.KandK.ProbMeanCurves.Running_Shoe_C.MOMENTS.HIP.Y([20:181],:),2))),'linewidth', 1 ,'LineStyle', (stlye{1, 3}), 'color', (farbe{1, 3}))


set(gca,'Fontname','CMU Sans Serif')
set(gca, 'FontSize', schriftgr);
set(gca, 'linewidth', 2)
set(gcf,'color','w');
set(gca, 'FontSize', schriftgr);
box off
set(gca,'xtick',[]);
set(gca,'xcolor',[1 1 1])
xlim([1, 161]);
ylabel ('Sagittal [Nm/kg]')
subplot(3,1,3)
set(gca,'xcolor',[0 0 0])
plot(DATA.KandK.ProbMeanCurves.Running_Shoe_A.MOMENTS.HIP.Z([20:181],demoofsubjectrow),'linewidth', 4 ,'LineStyle', (stlye{1, 1}), 'color', (farbe{1, 1}))
hold on
plot(DATA.KandK.ProbMeanCurves.Running_Shoe_B.MOMENTS.HIP.Z([20:181],demoofsubjectrow),'linewidth', 4 ,'LineStyle', (stlye{1, 2}), 'color', (farbe{1, 2}))
plot(DATA.KandK.ProbMeanCurves.Running_Shoe_C.MOMENTS.HIP.Z([20:181],demoofsubjectrow),'linewidth', 4 ,'LineStyle', (stlye{1, 3}), 'color', (farbe{1, 3}))
plot(((mean(DATA.KandK.ProbMeanCurves.Running_Shoe_A.MOMENTS.HIP.Z([20:181],:),2))),'linewidth', 1 ,'LineStyle', (stlye{1, 1}), 'color', (farbe{1, 1}))
plot(((mean(DATA.KandK.ProbMeanCurves.Running_Shoe_B.MOMENTS.HIP.Z([20:181],:),2))),'linewidth', 1 ,'LineStyle', (stlye{1,2 }), 'color', (farbe{1, 2}))
plot(((mean(DATA.KandK.ProbMeanCurves.Running_Shoe_C.MOMENTS.HIP.Z([20:181],:),2))),'linewidth', 1 ,'LineStyle', (stlye{1, 3}), 'color', (farbe{1, 3}))


set(gca,'Fontname','CMU Sans Serif')
set(gca, 'FontSize', schriftgr);
set(gca, 'linewidth', 2)
set(gcf,'color','w');
set(gca, 'FontSize', schriftgr);
xlabel ('% der St�tzphase')
xticks([1 181/2-181/4-20 181/2-20 181/2+(181/4)-20 181-20])
xticklabels({'0','25','50','75', '100'})
box off
xlim([1, 161]);
ylabel ('Transversal [Nm/kg]')

figHipMom.Snapshot.Caption = sprintf('Drehmomente an der H�fte in allen 3 Raumebenen, d�nnen Linien zeigen dabei den Gruppenmittelwert aller Probanden.');
figHipMom.Snapshot.Height = '5in';
figHipMom.Snapshot.Width = '6in';

add(sec43,figHipMom);  % add the figure to section


%knee mom
figure()
figKneeMom = mlreportgen.report.Figure(gcf);


subplot(3,1,1)
plot(DATA.KandK.ProbMeanCurves.Running_Shoe_A.MOMENTS.KNEE.X([20:181],demoofsubjectrow),'linewidth', 4 ,'LineStyle', (stlye{1, 1}), 'color', (farbe{1, 1}))
hold on
plot(DATA.KandK.ProbMeanCurves.Running_Shoe_B.MOMENTS.KNEE.X([20:181],demoofsubjectrow),'linewidth', 4 ,'LineStyle', (stlye{1, 2}), 'color', (farbe{1, 2}))
plot(DATA.KandK.ProbMeanCurves.Running_Shoe_C.MOMENTS.KNEE.X([20:181],demoofsubjectrow),'linewidth', 4 ,'LineStyle', (stlye{1, 3}), 'color', (farbe{1, 3}))
plot(((mean(DATA.KandK.ProbMeanCurves.Running_Shoe_A.MOMENTS.KNEE.X([20:181],:),2))),'linewidth', 1 ,'LineStyle', (stlye{1, 1}), 'color', (farbe{1, 1}))
plot(((mean(DATA.KandK.ProbMeanCurves.Running_Shoe_B.MOMENTS.KNEE.X([20:181],:),2))),'linewidth', 1 ,'LineStyle', (stlye{1,2 }), 'color', (farbe{1, 2}))
plot(((mean(DATA.KandK.ProbMeanCurves.Running_Shoe_C.MOMENTS.KNEE.X([20:181],:),2))),'linewidth', 1 ,'LineStyle', (stlye{1, 3}), 'color', (farbe{1, 3}))


ylabel ('Frontal [Nm/kg]')
set(gca,'Fontname','CMU Sans Serif')
set(gca, 'FontSize', schriftgr);
set(gca, 'linewidth', 2)
set(gcf,'color','w');
set(gca, 'FontSize', schriftgr);
box off
set(gca,'xtick',[]);
set(gca,'xcolor',[1 1 1])
xlim([1, 161]);
subplot(3,1,2)

plot(DATA.KandK.ProbMeanCurves.Running_Shoe_A.MOMENTS.KNEE.Y([20:181],demoofsubjectrow),'linewidth', 4 ,'LineStyle', (stlye{1, 1}), 'color', (farbe{1, 1}))
hold on
plot(DATA.KandK.ProbMeanCurves.Running_Shoe_B.MOMENTS.KNEE.Y([20:181],demoofsubjectrow),'linewidth', 4 ,'LineStyle', (stlye{1, 2}), 'color', (farbe{1, 2}))
plot(DATA.KandK.ProbMeanCurves.Running_Shoe_C.MOMENTS.KNEE.Y([20:181],demoofsubjectrow),'linewidth', 4 ,'LineStyle', (stlye{1, 3}), 'color', (farbe{1, 3}))
plot(((mean(DATA.KandK.ProbMeanCurves.Running_Shoe_A.MOMENTS.KNEE.Y([20:181],:),2))),'linewidth', 1 ,'LineStyle', (stlye{1, 1}), 'color', (farbe{1, 1}))
plot(((mean(DATA.KandK.ProbMeanCurves.Running_Shoe_B.MOMENTS.KNEE.Y([20:181],:),2))),'linewidth', 1 ,'LineStyle', (stlye{1,2 }), 'color', (farbe{1, 2}))
plot(((mean(DATA.KandK.ProbMeanCurves.Running_Shoe_C.MOMENTS.KNEE.Y([20:181],:),2))),'linewidth', 1 ,'LineStyle', (stlye{1, 3}), 'color', (farbe{1, 3}))



set(gca,'Fontname','CMU Sans Serif')
set(gca, 'FontSize', schriftgr);
set(gca, 'linewidth', 2)
set(gcf,'color','w');
set(gca, 'FontSize', schriftgr);
box off
set(gca,'xtick',[]);
set(gca,'xcolor',[1 1 1])
xlim([1, 161]);
ylabel ('Sagittal [Nm/kg]')
subplot(3,1,3)
set(gca,'xcolor',[0 0 0])
plot(DATA.KandK.ProbMeanCurves.Running_Shoe_A.MOMENTS.KNEE.Z([20:181],demoofsubjectrow),'linewidth', 4 ,'LineStyle', (stlye{1, 1}), 'color', (farbe{1, 1}))
hold on
plot(DATA.KandK.ProbMeanCurves.Running_Shoe_B.MOMENTS.KNEE.Z([20:181],demoofsubjectrow),'linewidth', 4 ,'LineStyle', (stlye{1, 2}), 'color', (farbe{1, 2}))
plot(DATA.KandK.ProbMeanCurves.Running_Shoe_C.MOMENTS.KNEE.Z([20:181],demoofsubjectrow),'linewidth', 4 ,'LineStyle', (stlye{1, 3}), 'color', (farbe{1, 3}))
plot(((mean(DATA.KandK.ProbMeanCurves.Running_Shoe_A.MOMENTS.KNEE.Z([20:181],:),2))),'linewidth', 1 ,'LineStyle', (stlye{1, 1}), 'color', (farbe{1, 1}))
plot(((mean(DATA.KandK.ProbMeanCurves.Running_Shoe_B.MOMENTS.KNEE.Z([20:181],:),2))),'linewidth', 1 ,'LineStyle', (stlye{1,2 }), 'color', (farbe{1, 2}))
plot(((mean(DATA.KandK.ProbMeanCurves.Running_Shoe_C.MOMENTS.KNEE.Z([20:181],:),2))),'linewidth', 1 ,'LineStyle', (stlye{1, 3}), 'color', (farbe{1, 3}))



set(gca,'Fontname','CMU Sans Serif')
set(gca, 'FontSize', schriftgr);
set(gca, 'linewidth', 2)
set(gcf,'color','w');
set(gca, 'FontSize', schriftgr);
xlabel ('% der St�tzphase')
xticks([1 181/2-181/4-20 181/2-20 181/2+(181/4)-20 181-20])
xticklabels({'0','25','50','75', '100'})
box off
xlim([1, 161]);
ylabel ('Transversal [Nm/kg]')

figKneeMom.Snapshot.Caption = sprintf('Drehmomente am Knie in allen 3 Raumebenen, d�nnen Linien zeigen dabei den Gruppenmittelwert aller Probanden.');
figKneeMom.Snapshot.Height = '5in';
figKneeMom.Snapshot.Width = '6in';

add(sec43,figKneeMom);  % add the figure to section


%knee mom
figure()
figAnkleMom = mlreportgen.report.Figure(gcf);


subplot(3,1,1)
plot(DATA.KandK.ProbMeanCurves.Running_Shoe_A.MOMENTS.ANKLE.X([20:181],demoofsubjectrow),'linewidth', 4 ,'LineStyle', (stlye{1, 1}), 'color', (farbe{1, 1}))
hold on
plot(DATA.KandK.ProbMeanCurves.Running_Shoe_B.MOMENTS.ANKLE.X([20:181],demoofsubjectrow),'linewidth', 4 ,'LineStyle', (stlye{1, 2}), 'color', (farbe{1, 2}))
plot(DATA.KandK.ProbMeanCurves.Running_Shoe_C.MOMENTS.ANKLE.X([20:181],demoofsubjectrow),'linewidth', 4 ,'LineStyle', (stlye{1, 3}), 'color', (farbe{1, 3}))
plot(((mean(DATA.KandK.ProbMeanCurves.Running_Shoe_A.MOMENTS.ANKLE.X([20:181],:),2))),'linewidth', 1 ,'LineStyle', (stlye{1, 1}), 'color', (farbe{1, 1}))
plot(((mean(DATA.KandK.ProbMeanCurves.Running_Shoe_B.MOMENTS.ANKLE.X([20:181],:),2))),'linewidth', 1 ,'LineStyle', (stlye{1,2 }), 'color', (farbe{1, 2}))
plot(((mean(DATA.KandK.ProbMeanCurves.Running_Shoe_C.MOMENTS.ANKLE.X([20:181],:),2))),'linewidth', 1 ,'LineStyle', (stlye{1, 3}), 'color', (farbe{1, 3}))



ylabel ('Frontal [Nm/kg]')
set(gca,'Fontname','CMU Sans Serif')
set(gca, 'FontSize', schriftgr);
set(gca, 'linewidth', 2)
set(gcf,'color','w');
set(gca, 'FontSize', schriftgr);
box off
set(gca,'xtick',[]);
set(gca,'xcolor',[1 1 1])
xlim([1, 161]);
subplot(3,1,2)

plot(DATA.KandK.ProbMeanCurves.Running_Shoe_A.MOMENTS.ANKLE.Y([20:181],demoofsubjectrow),'linewidth', 4 ,'LineStyle', (stlye{1, 1}), 'color', (farbe{1, 1}))
hold on
plot(DATA.KandK.ProbMeanCurves.Running_Shoe_B.MOMENTS.ANKLE.Y([20:181],demoofsubjectrow),'linewidth', 4 ,'LineStyle', (stlye{1, 2}), 'color', (farbe{1, 2}))
plot(DATA.KandK.ProbMeanCurves.Running_Shoe_C.MOMENTS.ANKLE.Y([20:181],demoofsubjectrow),'linewidth', 4 ,'LineStyle', (stlye{1, 3}), 'color', (farbe{1, 3}))
plot(((mean(DATA.KandK.ProbMeanCurves.Running_Shoe_A.MOMENTS.ANKLE.Y([20:181],:),2))),'linewidth', 1 ,'LineStyle', (stlye{1, 1}), 'color', (farbe{1, 1}))
plot(((mean(DATA.KandK.ProbMeanCurves.Running_Shoe_B.MOMENTS.ANKLE.Y([20:181],:),2))),'linewidth', 1 ,'LineStyle', (stlye{1,2 }), 'color', (farbe{1, 2}))
plot(((mean(DATA.KandK.ProbMeanCurves.Running_Shoe_C.MOMENTS.ANKLE.Y([20:181],:),2))),'linewidth', 1 ,'LineStyle', (stlye{1, 3}), 'color', (farbe{1, 3}))



set(gca,'Fontname','CMU Sans Serif')
set(gca, 'FontSize', schriftgr);
set(gca, 'linewidth', 2)
set(gcf,'color','w');
set(gca, 'FontSize', schriftgr);
box off
set(gca,'xtick',[]);
set(gca,'xcolor',[1 1 1])
xlim([1, 161]);
ylabel ('Sagittal [Nm/kg]')
subplot(3,1,3)
set(gca,'xcolor',[0 0 0])
plot(DATA.KandK.ProbMeanCurves.Running_Shoe_A.MOMENTS.ANKLE.Z([20:181],demoofsubjectrow),'linewidth', 4 ,'LineStyle', (stlye{1, 1}), 'color', (farbe{1, 1}))
hold on
plot(DATA.KandK.ProbMeanCurves.Running_Shoe_B.MOMENTS.ANKLE.Z([20:181],demoofsubjectrow),'linewidth', 4 ,'LineStyle', (stlye{1, 2}), 'color', (farbe{1, 2}))
plot(DATA.KandK.ProbMeanCurves.Running_Shoe_C.MOMENTS.ANKLE.Z([20:181],demoofsubjectrow),'linewidth', 4 ,'LineStyle', (stlye{1, 3}), 'color', (farbe{1, 3}))
plot(((mean(DATA.KandK.ProbMeanCurves.Running_Shoe_A.MOMENTS.ANKLE.Z([20:181],:),2))),'linewidth', 1 ,'LineStyle', (stlye{1, 1}), 'color', (farbe{1, 1}))
plot(((mean(DATA.KandK.ProbMeanCurves.Running_Shoe_B.MOMENTS.ANKLE.Z([20:181],:),2))),'linewidth', 1 ,'LineStyle', (stlye{1,2 }), 'color', (farbe{1, 2}))
plot(((mean(DATA.KandK.ProbMeanCurves.Running_Shoe_C.MOMENTS.ANKLE.Z([20:181],:),2))),'linewidth', 1 ,'LineStyle', (stlye{1, 3}), 'color', (farbe{1, 3}))



set(gca,'Fontname','CMU Sans Serif')
set(gca, 'FontSize', schriftgr);
set(gca, 'linewidth', 2)
set(gcf,'color','w');
set(gca, 'FontSize', schriftgr);
xlabel ('% der St�tzphase')
xticks([1 181/2-181/4-20 181/2-20 181/2+(181/4)-20 181-20])
xticklabels({'0','25','50','75', '100'})
box off
xlim([1, 161]);
ylabel ('Transversal [Nm/kg]')

figAnkleMom.Snapshot.Caption = sprintf('Drehmomente am Sprunggelenk in allen 3 Raumebenen, d�nnen Linien zeigen dabei den Gruppenmittelwert aller Probanden.');
figAnkleMom.Snapshot.Height = '5in';
figAnkleMom.Snapshot.Width = '6in';

add(sec43,figAnkleMom);  % add the figure to section



add(rpt,ch4);
delete(gcf)
close(rpt)
rptview(rpt)



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Additional Funs %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [v, f, n, c, stltitle] = stlread2(filename, verbose)
% This function reads an STL file in binary format into vertex and face
% matrices v and f.
%
% USAGE: [v, f, n, c, stltitle] = stlread(filename, verbose);
%
% verbose is an optional logical argument for displaying some loading
%   information (default is false).
%
% v contains the vertices for all triangles [3*n x 3].
% f contains the vertex lists defining each triangle face [n x 3].
% n contains the normals for each triangle face [n x 3].
% c is optional and contains color rgb data in 5 bits [n x 3].
% stltitle contains the title of the specified stl file [1 x 80].
%
% To see plot the 3D surface use:
%   patch('Faces',f,'Vertices',v,'FaceVertexCData',c);
% or
%   plot3(v(:,1),v(:,2),v(:,3),'.');
%
% Duplicate vertices can be removed using:
%   [v, f]=patchslim(v, f);
%
% For more information see:
%  http://www.esmonde-white.com/home/diversions/matlab-program-for-loading-stl-files
%
% Based on code originally written by:
%    Doron Harlev
% and combined with some code by:
%    Eric C. Johnson, 11-Dec-2008
%    Copyright 1999-2008 The MathWorks, Inc.
%
% Re-written and optimized by Francis Esmonde-White, May 2010.

use_color=(nargout>=4);

fid=fopen(filename, 'r'); %Open the file, assumes STL Binary format.
if fid == -1
    error('File could not be opened, check name or path.')
end

if ~exist('verbose','var')
    verbose = false;
end

ftitle=fread(fid,80,'uchar=>schar'); % Read file title
numFaces=fread(fid,1,'int32'); % Read number of Faces

T = fread(fid,inf,'uint8=>uint8'); % read the remaining values
fclose(fid);

stltitle = char(ftitle');

if verbose
    fprintf('\nTitle: %s\n', stltitle);
    fprintf('Number of Faces: %d\n', numFaces);
    disp('Please wait...');
end

% Each facet is 50 bytes
%  - Three single precision values specifying the face normal vector
%  - Three single precision values specifying the first vertex (XYZ)
%  - Three single precision values specifying the second vertex (XYZ)
%  - Three single precision values specifying the third vertex (XYZ)
%  - Two color bytes (possibly zeroed)

% 3 dimensions x 4 bytes x 4 vertices = 48 bytes for triangle vertices
% 2 bytes = color (if color is specified)

trilist = 1:48;

ind = reshape(repmat(50*(0:(numFaces-1)),[48,1]),[1,48*numFaces])+repmat(trilist,[1,numFaces]);
Tri = reshape(typecast(T(ind),'single'),[3,4,numFaces]);

n=squeeze(Tri(:,1,:))';
n=double(n);

v=Tri(:,2:4,:);
v = reshape(v,[3,3*numFaces]);
v = double(v)';

f = reshape(1:3*numFaces,[3,numFaces])';

if use_color
    c0 = typecast(T(49:50),'uint16');
    if (bitget(c0(1),16)==1)
        trilist = 49:50;
        ind = reshape(repmat(50*(0:(numFaces-1)),[2,1]),[1,2*numFaces])+repmat(trilist,[1,numFaces]);
        c0 = reshape(typecast(T(ind),'uint16'),[1,numFaces]);
        
        r=bitshift(bitand(2^16-1, c0),-10);
        g=bitshift(bitand(2^11-1, c0),-5);
        b=bitand(2^6-1, c0);
        c=[r; g; b]';
    else
        c = zeros(numFaces,3);
    end
end

if verbose
    disp('Done!');
end
end



function [vnew, fnew]=patchslim(v, f)
% PATCHSLIM removes duplicate vertices in surface meshes.
%
% This function finds and removes duplicate vertices.
%
% USAGE: [v, f]=patchslim(v, f)
%
% Where v is the vertex list and f is the face list specifying vertex
% connectivity.
%
% v contains the vertices for all triangles [3*n x 3].
% f contains the vertex lists defining each triangle face [n x 3].
%
% This will reduce the size of typical v matrix by about a factor of 6.
%
% For more information see:
%  http://www.esmonde-white.com/home/diversions/matlab-program-for-loading-stl-files
%
% Francis Esmonde-White, May 2010

if ~exist('v','var')
    error('The vertex list (v) must be specified.');
end
if ~exist('f','var')
    error('The vertex connectivity of the triangle faces (f) must be specified.');
end

[vnew, indexm, indexn] =  unique(v, 'rows');
fnew = indexn(f);
end
function varargout = smoothMesh(varargin)
%SMOOTHMESH Smooth mesh by replacing each vertex by the average of its neighbors.
%
%   V2 = smoothMesh(V, F)
%   [V2, F2] = smoothMesh(V, F)
%   Performs smoothing of the values given in V, by using adjacency
%   information given in F.
%   V is a numeric array representing either vertex coordinate, or value
%   field associated to each vertex. F is an array of faces, given either
%   as a NF-by-3 or NF-by-4 numeric array, or as a cell array.
%   Artifact adjacencies are added if faces have more than 4 vertices.
%
%   ... = smoothMesh(V, F, NITER)
%   Repeat the smoothing procedure NITER times. This is equivalent to
%   calling the smoothMesh function NITER times.
%
%
%   Example
%     [v f] = torusMesh([50 50 50 30 10 30 45]);
%     v = v + randn(size(v));
%     [v2 f] = smoothMesh(v, f, 3);
%     figure; drawMesh(v2, f);
%     l = light; lighting gouraud
%
%   See also
%     meshes3d, meshAdjacencyMatrix, triangulateFaces, drawMesh
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2013-04-29,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2013 INRA - Cepia Software Platform.

var1 = varargin{1};
if isstruct(var1)
    vertices = var1.vertices;
    faces = var1.faces;
    varargin(1) = [];
else
    vertices = varargin{1};
    faces = varargin{2};
    varargin(1:2) = [];
end

% determine number of iterations
nIter = 1;
if ~isempty(varargin)
    nIter = varargin{1};
end

% compute adjacency matrix,
% result is a Nv-by-Nv matrix with zeros on the diagonal
adj = meshAdjacencyMatrix(faces);

% ensure the size of the matrix is Nv-by-Nv
% (this can not be the case if some vertices are not referenced)
nv = size(vertices, 1);
if size(adj, 1) < nv
    adj(nv, nv) = 0;
end

% Add "self adjacencies"
adj = adj + speye(nv);

% weight each vertex by the number of its neighbors
w = spdiags(full(sum(adj, 2).^(-1)), 0, nv, nv);
adj = w * adj;

% do averaging to smooth the field
v2 = vertices;
for k = 1:nIter
    v2 = adj * v2;
end

varargout = formatMeshOutput(nargout, v2, faces);

%% Old version
% % Compute vertex adjacencies
% edges = computeMeshEdges(faces);
% v2 = zeros(size(vertices));
%
% % apply several smoothing
% for iter = 1:nIter
%
%     % replace the coords of each vertex by the average coordinate in the
%     % neighborhood
%     for i = 1:size(vertices, 1)
%         edgeInds = sum(edges == i, 2) > 0;
%         neighInds = unique(edges(edgeInds, :));
%         v2(i, :) = mean(vertices(neighInds, :));
%     end
%
%     % update for next iteration
%     vertices = v2;
% end
end
function res = formatMeshOutput(nbArgs, vertices, edges, faces)
%FORMATMESHOUTPUT Format mesh output depending on nargout.
%
%   OUTPUT = formatMeshOutput(NARGOUT, VERTICES, EDGES, FACES)
%   Utilitary function to convert mesh data .
%   If NARGOUT is 0 or 1, return a matlab structure with fields vertices,
%   edges and faces.
%   If NARGOUT is 2, return a cell array with data VERTICES and FACES.
%   If NARGOUT is 3, return a cell array with data VERTICES, EDGES and
%   FACES.
%
%   OUTPUT = formatMeshOutput(NARGOUT, VERTICES, FACES)
%   Same as before, but do not intialize EDGES in output. NARGOUT can not
%   be equal to 3.
%
%   Example
%     % Typical calling sequence (for a very basic mesh of only one face)
%     v = [0 0; 0 1;1 0;1 1];
%     e = [1 2;1 3;2 4;3 4];
%     f = [1 2 3 4];
%
%     varargout = formatMeshOutput(nargout, v, e, f);
%
%   See also
%   meshes3d, parseMeshData
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-12-06,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

if nargin < 4
    faces = edges;
    edges = [];
end

switch nbArgs
    case {0, 1}
        % output is a data structure with fields vertices, edges and faces
        mesh.vertices = vertices;
        if ~isempty(edges)
            mesh.edges = edges;
        end
        mesh.faces = faces;
        res = {mesh};
        
    case 2
        % keep only vertices and faces
        res = cell(nbArgs, 1);
        res{1} = vertices;
        res{2} = faces;
        
    case 3
        % return vertices, edges and faces as 3 separate outputs
        res = cell(nbArgs, 1);
        res{1} = vertices;
        res{2} = edges;
        res{3} = faces;
        
    otherwise
        error('Can not manage more than 3 outputs');
end

end
