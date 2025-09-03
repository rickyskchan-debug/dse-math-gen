uses sysutils;

var n,i,j,k,t,p,chapter_count:longint;
	Qtop:longint;
	Q_code,Q_ExYr,Q_PaperType,Q_PaperSection:array[1..10000] of string;
	Q_Qno,Q_Mark,Q_Syl_num,Q_Ch_num,Q_sec_num:array[1..10000] of longint;
	syl:array [1..10] of string;
	syl_top:longint;
	chapter_top:array[1..10] of longint;
	chapter_name:array[1..10,0..20] of string;
	section_name:array[1..10,0..20,1..10] of string;
	section_top:array[1..10,0..20] of longint;
	tempstring:string;
	paper_shortcode,paper_code:array[1..30] of string;
	papertop:longint;
	papersection_name:array[0..6] of string;
	papersection_top:longint;
	Fx:text;
	str1,str2:string;
	print_section_summary:boolean;
	Q_Queue:array[1..1200] of string;
	Q_Queue_top:longint;
	weight:array[1..10,0..20] of longint;
	Q_bank:array[1..10,0..20,1..10,1..10,1..200] of longint;
	Q_bank_R,Q_bank_L:array[1..10,0..20,1..10,1..10] of longint;
	Mark_Form,Mark_Form_P1,Mark_Form_P2:array[1..10] of longint;
	Mark_Chapter,Mark_Chapter_P1,Mark_Chapter_P2:array[1..10,0..20] of longint;
	Mark_Section,Mark_Section_P1,Mark_Section_P2:array[1..10,0..20,1..10] of longint;
	Mark_Section_PaperSection,Mark_Section_PaperSection_P1,Mark_Section_PaperSection_P2:array[1..10,0..20,1..10,1..10] of longint;
	Mark_Stream,Mark_Stream_P1,Mark_Stream_P2:array[1..4] of longint;
	Graph_top:longint;
	Graph_xticks:Array[1..30] of string;
	Graph_barheight:Array[1..30] of longint;
	Graph_y_label:string;

procedure print_file_header;
begin

writeln('\documentclass[12pt, a4paper]{article}');
writeln;
writeln('\input{style.tex}');
writeln;
writeln;
writeln;
writeln('\begin{document}');

end;
	
procedure print_file_footer;
begin
	writeln('\end{document}');
end;

	
function tostring(k:longint):string;
var tempstring:string;
begin
	str(k,tempstring);
	exit(tempstring);
end;
	
procedure swap(var a:longint;var b:longint);
var temp:longint;
begin
	temp:=a;
	a:=b;
	b:=temp;
end;
	
function Num(ch:char):longint;
begin
	exit(Ord(ch)-Ord('0'));
end;


function syl_num(str:string):longint;
var jj:longint;
begin
	for jj:=1 to syl_top do
	begin
		if (syl[jj]=str) then exit(jj);
	end;
	exit(0);
end;


function toNum(str:string):longint;
var len,i , ans:longint; 
begin
	len:=length(str);
	ans:=0;
	for i:=1 to len do
	begin
		ans:=ans*10;
		ans:=ans+Num(str[i]);
	end;
	exit(ans);
end;


function getyear(tt:longint):longint;
begin
	if (Q_ExYr[tt]='DSE2012S') then exit(2010);
	if (Q_ExYr[tt]='DSE2012P') then exit(2011);
	if (Q_ExYr[tt]='DSE2012') then exit(2012);
	if (Q_ExYr[tt]='DSE2013') then exit(2013);
	if (Q_ExYr[tt]='DSE2014') then exit(2014);
	if (Q_ExYr[tt]='DSE2015') then exit(2015);
	if (Q_ExYr[tt]='DSE2016') then exit(2016);
	if (Q_ExYr[tt]='DSE2017') then exit(2017);
	if (Q_ExYr[tt]='DSE2018') then exit(2018);
	if (Q_ExYr[tt]='DSE2019') then exit(2019);
	if (Q_ExYr[tt]='DSE2020') then exit(2020);
	if (Q_ExYr[tt]='DSE2021') then exit(2021);
	if (Q_ExYr[tt]='DSE2022') then exit(2022);
	if (Q_ExYr[tt]='DSE2023') then exit(2023);
	if (Q_ExYr[tt]='DSE2024') then exit(2024);
	if (Q_ExYr[tt]='DSE2025') then exit(2025);
	exit(0);
end;
	
function getpapersection(a,b:string):longint;
begin
	if ((a='CoreP1')and(b='A1')) then exit(1);
	if ((a='CoreP1')and(b='A2')) then exit(2);
	if ((a='CoreP1')and(b='B')) then exit(3);
	
	if ((a='CoreP2')and(b='A')) then exit(4);
	if ((a='CoreP2')and(b='B')) then exit(5);
	
	if ((a='CoreP1')and(b='C')) then exit(6);
	if ((a='CoreP2')and(b='C')) then exit(6);
	exit(0);
end;

	
	
procedure graph_clear;
begin
	Graph_top:=0;
	Graph_y_label:='';
end;
	
procedure graph_add_bar(s:string;kk:longint);
var ii:longint;
begin
	inc(Graph_top);
	ii:=Graph_top;
	Graph_xticks[ii]:=s;
	Graph_barheight[ii]:=kk;
end;

procedure graph_print;
var jj:longint;
begin

	writeln('%Graph');
	writeln('\begin{center}');
	writeln('\begin{tikzpicture}');
	writeln('\begin{axis}[');
	writeln('width=18cm,');
	writeln('height=7cm,');
	writeln('bar width=0.6cm,');
	writeln('ybar,');
	writeln('ylabel={', Graph_y_label ,'},');
	writeln('xticklabels={');
	for jj:= 1 to Graph_top do
	begin
		write(Graph_xticks[jj]);
		if (jj<Graph_top) then write(',');
	end;
	writeln('},');
	writeln('xtick=data,');
	writeln('ymin=0,');
	writeln('nodes near coords,');
	writeln('nodes near coords align={vertical},');
	writeln('x tick label style={rotate=45,anchor=east},');
	writeln(']');
	write('\addplot coordinates {');
	for jj:= 1 to Graph_top do
	begin
		write('(',jj,',',Graph_barheight[jj],')');
	end;
	writeln('};');
	writeln('\end{axis}');
	writeln('\end{tikzpicture}');
	writeln('\end{center}');
	writeln;
	writeln;
	writeln;

end;

procedure survey;
var tt,ii,jj,kk,ll,pp,iii,jjj,x1,x2:longint;
begin

//reset Q_bank
for ii:=1 to syl_top do
for jj:=1 to chapter_top[ii] do
for kk:=1 to section_top[ii,jj] do
for pp:=1 to papersection_top do
begin
	Q_bank_L[ii,jj,kk,pp]:=1;
	Q_bank_R[ii,jj,kk,pp]:=0;
end;

//input Q_bank
for tt:=1 to Qtop do
begin
	ii:=Q_Syl_num[tt];
	jj:=Q_Ch_num[tt];
	kk:=Q_sec_num[tt];
	pp:=getpapersection(Q_PaperType[tt],Q_PaperSection[tt]);
	inc(Q_bank_R[ii,jj,kk,pp]);
	ll:=Q_bank_R[ii,jj,kk,pp];
	Q_bank[ii,jj,kk,pp,ll]:=tt;
end;

// sort
for ii:=1 to syl_top do
for jj:=1 to chapter_top[ii] do
for kk:=1 to section_top[ii,jj] do
for pp:=1 to papersection_top do
begin
	if (Q_bank_L[ii,jj,kk,pp]<Q_bank_R[ii,jj,kk,pp]) then
	begin
		for iii:=1 to Q_bank_R[ii,jj,kk,pp]-1 do 
		for jjj:=Q_bank_R[ii,jj,kk,pp] downto iii+1 do
		begin
			x1:=Q_bank[ii,jj,kk,pp,jjj-1];
			x2:=Q_bank[ii,jj,kk,pp,jjj];
			if ((getyear(x2)<getyear(x1))or((getyear(x2)=getyear(x1))and(Q_Qno[x2]<Q_Qno[x1]))) then
			begin
				swap(Q_bank[ii,jj,kk,pp,jjj],Q_bank[ii,jj,kk,pp,jjj-1]);
			end;
		end;
	end;
end;


// Calculate Mark_Form, Mark_Chapter, Mark_Section, Mark_Section_PaperSection
for ii:=1 to syl_top do
begin
	Mark_Form[ii]:=0;
	Mark_Form_P1[ii]:=0;
	Mark_Form_P2[ii]:=0;
	for jj:=1 to chapter_top[ii] do
	begin
		Mark_Chapter[ii,jj]:=0;
		Mark_Chapter_P1[ii,jj]:=0;
		Mark_Chapter_P2[ii,jj]:=0;
		
		for kk:=1 to section_top[ii,jj] do
		begin
			Mark_Section[ii,jj,kk]:=0;
			Mark_Section_P1[ii,jj,kk]:=0;
			Mark_Section_P2[ii,jj,kk]:=0;

			for pp:=1 to papersection_top do
			begin
				Mark_Section_PaperSection[ii,jj,kk,pp]:=0;
				Mark_Section_PaperSection_P1[ii,jj,kk,pp]:=0;
				Mark_Section_PaperSection_P2[ii,jj,kk,pp]:=0;
			
				for ll:=1 to Q_bank_R[ii,jj,kk,pp] do
				begin
					tt:=Q_bank[ii,jj,kk,pp,ll];
					
					if (Q_PaperType[tt]='CoreP1') then
					begin
						inc(Mark_Section_PaperSection_P1[ii,jj,kk,pp],Q_Mark[tt]);
						inc(Mark_Section_PaperSection[ii,jj,kk,pp],Q_Mark[tt]);
					end
					else if (Q_PaperType[tt]='CoreP2') then
					begin
						inc(Mark_Section_PaperSection_P2[ii,jj,kk,pp],Q_Mark[tt]);
						inc(Mark_Section_PaperSection[ii,jj,kk,pp],Q_Mark[tt]);
					end;
					
				end;
				
				inc(Mark_Section_P1[ii,jj,kk],Mark_Section_PaperSection_P1[ii,jj,kk,pp]);
				inc(Mark_Section_P2[ii,jj,kk],Mark_Section_PaperSection_P2[ii,jj,kk,pp]);
				inc(Mark_Section[ii,jj,kk],Mark_Section_PaperSection[ii,jj,kk,pp]);
				
			end;
			
			inc(Mark_Chapter_P1[ii,jj],Mark_Section_P1[ii,jj,kk]);
			inc(Mark_Chapter_P2[ii,jj],Mark_Section_P2[ii,jj,kk]);
			inc(Mark_Chapter[ii,jj],Mark_Section[ii,jj,kk]);
		end;

		inc(Mark_Form_P1[ii],Mark_Chapter_P1[ii,jj]);
		inc(Mark_Form_P2[ii],Mark_Chapter_P2[ii,jj]);
		inc(Mark_Form[ii],Mark_Chapter[ii,jj]);
	end;

end;




end;
	
	
	
procedure QQueue_reset;
begin
	Q_Queue_top:=0;
end;

procedure QQueue_add(s:string);
begin
	inc(Q_Queue_top);
	Q_Queue[Q_Queue_top]:=s;
end;
	
procedure print_QQueue;
var ii,jj:longint;
begin

if (Q_Queue_top>0) then
begin

	writeln;
	writeln;
	writeln('\section*{Reference of each question}');
	writeln('\begin{tabular}{llll}');

	jj:=1;
	while (true) do
	begin
		for ii:=1 to 4 do
		begin
			if (jj<=Q_Queue_top) then
			begin
				if(jj<10) then write('$\phantom{\text{1}}$');
				write(jj,' . [',Q_Queue[jj],']');
				inc(jj);
			end;
			if (ii<4) then write(' & ');
		end;
		writeln('\\');
		if (jj>Q_Queue_top) then break;
	end;

	writeln('\end{tabular}');
	
end;


end;
	
	
procedure new_chapter_header(x,y:longint);
var temp_sec,temptitle,tempstring:string;
begin
	str(y,tempstring);
	temp_sec:=syl[x]+'-Ch'+tempstring;
	temptitle:=chapter_name[x,y];

	writeln('\newpage');
	writeln('\thispagestyle{empty}');
	writeln('\setcounter{page}{1}');
	writeln('\rhead{',temptitle,'}');
	writeln('\lfoot{',temp_sec,'}');
	writeln('\begin{center}');
	writeln('Mathematics Revision Notes\\\vspace{1cm}');
	writeln('\greybox{',temp_sec,'}\\\vspace{1cm}');
	writeln('{\fontsize{24pt}{24pt}\selectfont {',temptitle,'}} \\\vspace{1cm}');
	writeln('');
	writeln('\end{center}');
	writeln('\vspace{0.5cm}');
	writeln('\hline');
end;


procedure section_list(x,y:longint);
var z:longint;
begin


	writeln('\section*{Section List}');
	writeln('\begin{enumx}[label=',y,'.\arabic*\ ]');
	
	for z:=1 to section_top[i,j] do
	begin
		writeln('\item ', section_name[x,y,z] ,'\hfill P. \pageref{section:',x,'-',y,'-',z,'}');

	end;
	
	writeln('\end{enumx}');
	
end;



procedure new_section_header(x,y,z:longint);
begin
	writeln('\section*{Section ',y,'.',z,' - ',section_name[x,y,z],'}\phantomsection\label{section:',x,'-',y,'-',z,'}');
	if (print_section_summary) then
	begin
		str(y,str1);
		str(z,str2);
		//writeln('\input{D:/Math_Database/SectionSummary/',syl[x]+'-ch'+str1+'-sec'+str2+'.tex','}');
	end;
	
end;

procedure new_section_header_answer(x,y,z:longint);
begin
	writeln('\textbf{Section ',y,'.',z,' - ',section_name[x,y,z],'}\\');
end;


	
	
procedure parse(line:string);
var Len, sp:longint;
begin
	Len:=length(line);

	inc(Qtop);
	
	sp:=pos(' ',line);
	Q_code[Qtop]:=copy(line,1,sp-1);
	line:=copy(line,sp+1,len);
	
	sp:=pos(' ',line);
	Q_ExYr[Qtop]:=copy(line,1,sp-1);
	line:=copy(line,sp+1,len);
	
	sp:=pos(' ',line);
	Q_PaperType[Qtop]:=copy(line,1,sp-1);
	line:=copy(line,sp+1,len);
	
	sp:=pos(' ',line);
	Q_PaperSection[Qtop]:=copy(line,1,sp-1);
	line:=copy(line,sp+1,len);
	
	sp:=pos(' ',line);
	Q_Qno[Qtop]:=toNum(copy(line,1,sp-1));
	line:=copy(line,sp+1,len);
	
	sp:=pos(' ',line);
	Q_Mark[Qtop]:=toNum(copy(line,1,sp-1));
	line:=copy(line,sp+1,len);
	
	sp:=pos(' ',line);
	Q_Syl_num[Qtop]:=toNum(copy(line,1,sp-1));
	line:=copy(line,sp+1,len);
	
	sp:=pos(' ',line);
	Q_Ch_num[Qtop]:=toNum(copy(line,1,sp-1));
	line:=copy(line,sp+1,len);
	
	Q_sec_num[Qtop]:=toNum(line);
	
end;

procedure printstat(x,y:longint);
var ii,jj,p,t:longint;
	P1marks,P2marks:array[1..10,1..30] of longint;
begin

for ii:=1 to section_top[x,y] do
for jj:=1 to papertop do
begin
	P1marks[ii,jj]:=0;
	P2marks[ii,jj]:=0;
end;


for t:=1 to Qtop do
begin
	if Q_Syl_num[t]=x then
	if Q_Ch_num[t]=y then
	begin

		for p:=1 to papertop do
		begin
			if Q_ExYr[t]=paper_code[p] then
			begin
				if (Q_PaperType[t]='CoreP1') then
				begin
					inc(P1marks[Q_sec_num[t],p],Q_Mark[t]);
				end;
				
				if (Q_PaperType[t]='CoreP2') then
				begin
					inc(P2marks[Q_sec_num[t],p],Q_Mark[t]);
				end;
			end;
		end;
		
	end;
end;


writeln('\section*{Statistics}');

// CORE PAPER 1


writeln('\textbf{DSE Core Paper 1}');

writeln;
writeln('Number of marks related to each section of the chapter.');


writeln('\begin{center}');

write('\begin{tabular}{|l|');
for p:=1 to papertop do
begin
	write('c|');
end;
writeln('}');

writeln('\hline');

write('        ');
for p:=1 to papertop do
begin
	write('& ', paper_shortcode[p],' ');
end;
writeln('\\\hline\hline');

for ii:=1 to section_top[x,y] do
begin
	write('Sec ',y,'.',ii,' ');
	for p:=1 to papertop do
	begin
		write('& ');
		if (P1marks[ii,p]>0) then write(P1marks[ii,p]);
		write(' ');
	end;
	writeln('\\\hline');
end;

writeln('\end{tabular}');
writeln('\end{center}');



// CORE PAPER 2

writeln('\textbf{DSE Core Paper 2}');
writeln;
writeln('Number of questions related to each section of the chapter.');


writeln('\begin{center}');

write('\begin{tabular}{|l|');
for p:=1 to papertop do
begin
	write('c|');
end;
writeln('}');

writeln('\hline');

write('        ');
for p:=1 to papertop do
begin
	write('& ', paper_shortcode[p],' ');
end;
writeln('\\\hline\hline');

for ii:=1 to section_top[x,y] do
begin
	write('Sec ',y,'.',ii,' ');
	for p:=1 to papertop do
	begin
		write('& ');
		if (P2marks[ii,p]>0) then write(P2marks[ii,p]);
		write(' ');
	end;
	writeln('\\\hline');
end;

writeln('\end{tabular}');
writeln('\end{center}');

end;


function getshortcode(tt:longint):string;
var Yr:string;
	outP,outQ:string;
begin
	Yr:='=';
	outP:='-P0';
	outQ:='0';
	if (Q_ExYr[tt]='DSE2012S') then Yr:='Samp';
	if (Q_ExYr[tt]='DSE2012P') then Yr:='Prac';
	if (Q_ExYr[tt]='DSE2012') then Yr:='2012';
	if (Q_ExYr[tt]='DSE2013') then Yr:='2013';
	if (Q_ExYr[tt]='DSE2014') then Yr:='2014';
	if (Q_ExYr[tt]='DSE2015') then Yr:='2015';
	if (Q_ExYr[tt]='DSE2016') then Yr:='2016';
	if (Q_ExYr[tt]='DSE2017') then Yr:='2017';
	if (Q_ExYr[tt]='DSE2018') then Yr:='2018';
	if (Q_ExYr[tt]='DSE2019') then Yr:='2019';
	if (Q_ExYr[tt]='DSE2020') then Yr:='2020';
	if (Q_ExYr[tt]='DSE2021') then Yr:='2021';
	if (Q_ExYr[tt]='DSE2022') then Yr:='2022';
	if (Q_ExYr[tt]='DSE2023') then Yr:='2023';
	if (Q_ExYr[tt]='DSE2024') then Yr:='2024';
	if (Q_ExYr[tt]='DSE2025') then Yr:='2025';
	if (Q_PaperType[tt]='CoreP1') then outP:='-P1';
	if (Q_PaperType[tt]='CoreP2') then outP:='-P2';
	str(Q_Qno[tt],outQ);
	exit(Yr+outP+'-Q'+outQ);
end;

procedure printsectionsummary(x,y:longint);
var QArray:array[1..20,1..6,1..200] of longint;
	QA_L,QA_R:array[1..20,1..6] of longint;
	ii,jj,tt,iii,jjj,x1,x2:longint;
	cont:boolean;
	z,NextQ,t:longint;
begin

for ii:=1 to section_top[x,y] do
begin
	writeln;
	writeln('% ',syl[x],' Ch',y,' - ',y,'.',ii,' ',section_name[x,y,ii]);
	new_section_header(x,y,ii);
end;


end;









procedure printquestions(x,y:longint);
var ii,jj,kk,pp,tt,iii,jjj,x1,x2:longint;
	cont:boolean;
	z,NextQ,t:longint;
begin



QQueue_reset;
NextQ:=1;
for kk:=1 to section_top[x,y] do
begin 
	writeln;writeln;writeln;writeln;
	writeln('% ',syl[x],' Ch',y,' - ',y,'.',kk,' ',section_name[x,y,kk]);
	new_section_header(x,y,kk);
	writeln;
	
	for pp:=1 to papersection_top do
	begin
		Q_bank_L[x,y,kk,pp]:=1;
		
		if (Q_bank_L[x,y,kk,pp]<=Q_bank_R[x,y,kk,pp]) then
		begin
			writeln('\textbf{', papersection_name[pp] ,'}');
			writeln('\begin{enumx}[label=\arabic*.,start=',NextQ,']');
			while (Q_bank_L[x,y,kk,pp]<=Q_bank_R[x,y,kk,pp]) do
			begin
				tt:=Q_bank[x,y,kk,pp,Q_bank_L[x,y,kk,pp]];
				writeln('\phantomsection');
				writeln('\item \phantomsection\label{',Q_code[tt],'} \problem[',getshortcode(tt),']{',Q_code[tt],'}');
				QQueue_add(getshortcode(tt));
				inc(NextQ);
				inc(Q_bank_L[x,y,kk,pp]);
			end;
			writeln('\end{enumx}');	
		end;
		
	end;
end;	


//print_QQueue;


//print answers
if (NextQ>1) then 
begin
	
	writeln('\section*{Answers}');

	//writeln('\begin{multicols}{2}');
	
	writeln('\begin{enumx}[label=\arabic*.,start=',1,']');
	for kk:=1 to section_top[x,y] do
	begin 
		for pp:=1 to papersection_top do
		begin
			Q_bank_L[x,y,kk,pp]:=1;
			
			if (Q_bank_L[x,y,kk,pp]<=Q_bank_R[x,y,kk,pp]) then
			begin
				while (Q_bank_L[x,y,kk,pp]<=Q_bank_R[x,y,kk,pp]) do
				begin
					tt:=Q_bank[x,y,kk,pp,Q_bank_L[x,y,kk,pp]];
					writeln('\item \problemans{',Q_code[tt],'}');
					inc(Q_bank_L[x,y,kk,pp]);
				end;
			end;
			
		end;
	end;
	writeln('\end{enumx}');	

	//writeln('\end{multicols}');
	
end;
	
end;





































procedure printlist(x,y:longint);
var QArray:array[1..20,1..6,1..200] of longint;
	QA_L,QA_R:array[1..20,1..6] of longint;
	ii,jj,kk,tt,iii,jjj,x1,x2:longint;
	cont:boolean;
	z,NextQ,t:longint;
begin



for ii:=1 to section_top[x,y] do 
for jj:=1 to papersection_top do
begin
	QA_L[ii,jj]:=1;
	QA_R[ii,jj]:=0;
end;

for tt:=1 to Qtop do
begin
	if (Q_Syl_num[tt]=x) then
	if (Q_Ch_num[tt]=y) then
	begin
		ii:=Q_sec_num[tt];
		jj:=getpapersection(Q_PaperType[tt],Q_PaperSection[tt]);
		inc(QA_R[ii,jj]);
		QArray[ii,jj,QA_R[ii,jj]]:=tt;
	end;
end;

// SORT

for ii:=1 to section_top[x,y] do 
for jj:=1 to papersection_top do
begin
	if (QA_L[ii,jj]<QA_R[ii,jj]) then
	begin
		for iii:=QA_L[ii,jj] to QA_R[ii,jj]-1 do 
		for jjj:=QA_R[ii,jj] downto iii+1 do
		begin
			x1:=QArray[ii,jj,jjj-1];
			x2:=QArray[ii,jj,jjj];
			if ((getyear(x2)<getyear(x1))or((getyear(x2)=getyear(x1))and(Q_Qno[x2]<Q_Qno[x1]))) then
			begin
				swap(QArray[ii,jj,jjj],QArray[ii,jj,jjj-1])
			end;
		end;
	end;
end;




writeln('\section*{Table of related DSE Questions}');

writeln('The following questions test on contents related to the current chapter:');



// Print table

writeln('\begin{center}');

write('\begin{tabular}{|l|');
for ii:=1 to section_top[x,y] do
begin
	write('c|');
end;
writeln('}');

writeln('\hline');

write('        ');
for ii:=1 to section_top[x,y] do
begin
	write('& ',y,'.',ii,' ');
end;
writeln('\\\hline');

for jj:=1 to papersection_top do
begin
	if ((jj=1)or(jj=4)or(jj=6)) then writeln('\hline');
	write(papersection_name[jj]);
	while (true) do
	begin
		cont:=false;
		for ii:=1 to section_top[x,y] do
		begin
			write('& ');
			if (QA_L[ii,jj]<=QA_R[ii,jj]) then
			begin
				write('\hyperref[',Q_code[QArray[ii,jj,QA_L[ii,jj]]],']{',getshortcode(QArray[ii,jj,QA_L[ii,jj]]),'}');
				inc(QA_L[ii,jj]);
				if (QA_L[ii,jj]<=QA_R[ii,jj]) then cont:=true;
			end;
			write(' ');
		end;
		writeln('\\');
		if (cont=false) then break;
	end;
	writeln('\hline');
end;

writeln('\end{tabular}');
writeln('\end{center}');



///PRINT Qs	


QQueue_reset;
NextQ:=1;
for ii:=1 to section_top[x,y] do
begin 
	writeln;writeln;writeln;writeln;
	writeln('% ',syl[x],' Ch',y,' - ',y,'.',ii,' ',section_name[x,y,ii]);
	new_section_header(x,y,ii);
	writeln;
	
	for jj:=1 to papersection_top do
	begin
		QA_L[ii,jj]:=1;
		
		if (QA_L[ii,jj]<=QA_R[ii,jj]) then
		begin
			writeln('\textbf{', papersection_name[jj] ,'}');
			writeln('\begin{enumx}[label=\arabic*.,start=',NextQ,']');
			while (QA_L[ii,jj]<=QA_R[ii,jj]) do
			begin
				writeln('\item \phantomsection\label{',Q_code[QArray[ii,jj,QA_L[ii,jj]]],'} \problem[', getshortcode(QArray[ii,jj,QA_L[ii,jj]]) ,']{',Q_code[QArray[ii,jj,QA_L[ii,jj]]],'}');
				QQueue_add(getshortcode(QArray[ii,jj,QA_L[ii,jj]]));
				inc(NextQ);
				inc(QA_L[ii,jj]);
			end;
			writeln('\end{enumx}');	
		end;
		
	end;
end;	


//print_QQueue;


//print answers
if (NextQ>1) then 
begin
	
	writeln('\section*{Answers}');

	//writeln('\begin{multicols}{2}');
	
	writeln('\begin{enumx}[label=\arabic*.,start=',1,']');
	for ii:=1 to section_top[x,y] do
	begin 
		for jj:=1 to papersection_top do
		begin
			QA_L[ii,jj]:=1;
			
			if (QA_L[ii,jj]<=QA_R[ii,jj]) then
			begin
				while (QA_L[ii,jj]<=QA_R[ii,jj]) do
				begin
					writeln('\item \problemans{',Q_code[QArray[ii,jj,QA_L[ii,jj]]],'}');
					inc(QA_L[ii,jj]);
				end;
			end;
			
		end;
	end;
	writeln('\end{enumx}');	

	//writeln('\end{multicols}');
	
end;
	
end;


procedure print_Form_Header(a:longint);
begin

	writeln('\newpage');
	writeln('\thispagestyle{empty}');
	writeln('\rhead{Overview of S',a,' Chapters}');
	writeln('\lfoot{S',a,' Chapters}');
	writeln('\begin{center}');
	writeln('Mathematics Revision Notes\\\vspace{1cm}');
	writeln('\greybox{\fontsize{24pt}{24pt}\selectfont {S',a,' Chapters}} \\\vspace{1cm}');
	writeln('\end{center}');
	writeln('\vspace{0.5cm}');
	writeln('\hline');

end;

procedure print_Chapter_List(a:longint);
var ii:longint;
begin
	
	writeln('\begin{enumx}[label=Ch \arabic*. , leftmargin=2cm,rightmargin=0pt,labelwidth=17mm, itemsep=3pt, topsep=3mm, labelsep=2mm, labelindent=0pt, align=left, partopsep=0mm ]');
	for ii:= 1 to chapter_top[a] do
	begin
		writeln('\item \hyperref[', 'chapter:',syl[a],'-',ii,']{',chapter_name[a,ii],'} \hfill P.\pageref{chapter:',syl[a],'-',ii,'}');
	end;
	writeln('\end{enumx}');

end;

procedure reset_page;
begin

	writeln;
	writeln('\setcounter{page}{1}');
	writeln;
	
end;


procedure print_chapter_header(x,y:longint);
var temp_sec,temptitle:string;
begin

	temp_sec:=syl[x]+'-Ch'+tostring(y);
	temptitle:=chapter_name[x,y];

	writeln('\newpage');
	writeln('\thispagestyle{empty}');
	writeln('\rhead{',temptitle,'}');
	writeln('\lfoot{',temp_sec,'}');
	writeln('\begin{center}');
	writeln('Mathematics Revision Notes\\\vspace{1cm}');
	writeln('\greybox{',temp_sec,'}\\\vspace{1cm}');
	writeln('{\fontsize{24pt}{24pt}\selectfont {',temptitle,'}} \\\vspace{1cm}');
	writeln('\phantomsection\label{chapter:',syl[x],'-',y,'}');
	writeln('');
	writeln('\end{center}');
	writeln('\vspace{0.5cm}');
	writeln('\hline');

		
		

end;

procedure print_section_list_toc(x,y:longint);
var z:longint;
begin

	writeln('\begin{enumx}[label=Sec ',y,'.\arabic*\ ]');
	for z:=1 to section_top[i,j] do
	begin
		writeln('\item \hyperref[section:',x,'-',y,'-',z,']{', section_name[x,y,z] ,'} \hfill P. \pageref{section:',x,'-',y,'-',z,'}');
	end;
	writeln('\end{enumx}');
	
end;

procedure print_section_list(x,y:longint);
var z:longint;
begin

	writeln('\begin{enumx}[label=Sec ',y,'.\arabic*\ ]');
	for z:=1 to section_top[i,j] do
	begin
		writeln('\item \hyperref[section:',x,'-',y,'-',z,']{', section_name[x,y,z],'}');
	end;
	writeln('\end{enumx}');
	
end;


procedure print_section_P1_table(x,y:longint);
var p,kk,pp,n,ll,tt:longint;
begin

	writeln('\begin{center}');

	write('\begin{tabular}{|l|');
	for p:=1 to papertop do
	begin
		write('c|');
	end;
	writeln('}');

	writeln('\hline');

	write('        ');
	for p:=1 to papertop do
	begin
		write('& ', paper_shortcode[p],' ');
	end;
	writeln('\\\hline\hline');

	for kk:=1 to section_top[x,y] do
	begin
		write('Sec ',y,'.',kk,' ');
		for p:=1 to papertop do
		begin
			write('& ');
			
			n:=0;
			for pp:=1 to papersection_top do
			begin
				for ll:=1 to Q_bank_R[x,y,kk,pp] do
				begin
					tt:=Q_bank[x,y,kk,pp,ll];
					
					if (Q_PaperType[tt]='CoreP1') then
					if (Q_ExYr[tt]=paper_code[p]) then 
					begin
						inc(n,Q_Mark[tt]);
					end;					
				end;
			end;
			
			if (n>0) then write(' $',n,'$');
			write(' ');
			
		end;
		writeln('\\\hline');
	end;

	writeln('\end{tabular}');
	writeln('\end{center}');
	
end;







procedure print_section_P2_table(x,y:longint);
var p,kk,pp,n,ll,tt:longint;
begin

	writeln('\begin{center}');

	write('\begin{tabular}{|l|');
	for p:=1 to papertop do
	begin
		write('c|');
	end;
	writeln('}');

	writeln('\hline');

	write('        ');
	for p:=1 to papertop do
	begin
		write('& ', paper_shortcode[p],' ');
	end;
	writeln('\\\hline\hline');

	for kk:=1 to section_top[x,y] do
	begin
		write('Sec ',y,'.',kk,' ');
		for p:=1 to papertop do
		begin
			write('& ');
			
			n:=0;
			for pp:=1 to papersection_top do
			begin
				for ll:=1 to Q_bank_R[x,y,kk,pp] do
				begin
					tt:=Q_bank[x,y,kk,pp,ll];
					
					if (Q_PaperType[tt]='CoreP2') then
					if (Q_ExYr[tt]=paper_code[p]) then 
					begin
						inc(n,Q_Mark[tt]);
					end;					
				end;
			end;
			
			if (n>0) then write(' $',n,'$');
			write(' ');
			
		end;
		writeln('\\\hline');
	end;

	writeln('\end{tabular}');
	writeln('\end{center}');


end;

procedure print_chapter_question_table(x,y:longint);
var ii,jj,kk,pp:longint;
	cont:boolean;
begin

	writeln('\begin{center}');

	write('\begin{tabular}{|l|');
	for kk:=1 to section_top[x,y] do
	begin
		write('c|');
	end;
	writeln('}');

	writeln('\hline');

	write('        ');
	for kk:=1 to section_top[x,y] do
	begin
		write('& ',y,'.',kk,' ');
	end;
	writeln('\\\hline');

	for pp:=1 to papersection_top do
	for kk:=1 to section_top[x,y] do
		Q_bank_L[x,y,kk,pp]:=1;

	for pp:=1 to papersection_top do
	begin
		if ((pp=1)or(pp=4)or(pp=6)) then writeln('\hline');
		write(papersection_name[pp]);
		
		while (true) do
		begin
			cont:=false;
			for kk:=1 to section_top[x,y] do
			begin
				write('& ');
				if ( Q_bank_L[x,y,kk,pp]<=Q_bank_R[x,y,kk,pp]) then
				begin
					write('\hyperref[',Q_code[Q_bank[x,y,kk,pp,Q_bank_L[x,y,kk,pp]]],']{',getshortcode(Q_bank[x,y,kk,pp,Q_bank_L[x,y,kk,pp]]),'}');
					inc(Q_bank_L[x,y,kk,pp]);
					if (Q_bank_L[x,y,kk,pp]<=Q_bank_R[x,y,kk,pp]) then cont:=true;
				end;
				write(' ');
			end;
			writeln('\\');
			if (cont=false) then break;
		end;
		writeln('\hline');
	end;

	writeln('\end{tabular}');
	writeln('\end{center}');

end;




Begin
syl_top:=6;
syl[1]:='S1';
syl[2]:='S2';
syl[3]:='S3';
syl[4]:='S4';
syl[5]:='S5';
syl[6]:='S6';
syl[7]:='M1';
syl[8]:='M2';

chapter_top[1]:=13;
chapter_top[2]:=12;
chapter_top[3]:=12;
chapter_top[4]:=10;
chapter_top[5]:=11;
chapter_top[6]:=4;
chapter_top[7]:=0;
chapter_top[8]:=15;

chapter_name[8,1]:='Surds and Rationalization of Denominators';
chapter_name[8,2]:='Mathematical Induction';
chapter_name[8,3]:='Binomial Theorem';
chapter_name[8,4]:='Trigonometry (I)';
chapter_name[8,5]:='Trigonometry (II)';
chapter_name[8,6]:='Limits and the Number e ';
chapter_name[8,7]:='Differentiation';
chapter_name[8,8]:='Applications of Differentiation';
chapter_name[8,9]:='Indefinite Integration and its Applications';
chapter_name[8,10]:='Definite Integration';
chapter_name[8,11]:='Applications of Definite Integration';
chapter_name[8,12]:='Matrices and Determinants';
chapter_name[8,13]:='Systems of Linear Equations';
chapter_name[8,14]:='Introduction to Vectors';
chapter_name[8,15]:='Scalar Products and Vector Products';
chapter_name[1,1]:='Directed Numbers and the Number Line';
chapter_name[1,2]:='Introduction to Algebra';
chapter_name[1,3]:='Algebraic Equations in One Unknown';
chapter_name[1,4]:='Percentages (I)';
chapter_name[1,5]:='Estimation in Numbers and Measurement';
chapter_name[1,6]:='Introduction to Geometry';
chapter_name[1,7]:='Symmetry and Transformation';
chapter_name[1,8]:='Areas and Volumes (I)';
chapter_name[1,9]:='Congruence and Similarity';
chapter_name[1,10]:='Introduction to Coordinates';
chapter_name[1,11]:='Angles related to Lines';
chapter_name[1,12]:='Manipulation of Simple Polynomials';
chapter_name[1,13]:='Introduction of Statistics and Statistical Diagrams';
chapter_name[2,1]:='Rate and Ratio';
chapter_name[2,2]:='Identities and Factorization';
chapter_name[2,3]:='Algebraic Fractions and Formulas';
chapter_name[2,4]:='Approximation and Errors';
chapter_name[2,5]:='Angles related to Rectilinear Figures';
chapter_name[2,6]:='More about Statistical Diagrams';
chapter_name[2,7]:='Linear Equations in Two Unknowns';
chapter_name[2,8]:='Laws of Integral Indices';
chapter_name[2,9]:='Introduction to Deductive Geometry';
chapter_name[2,10]:='Pythagoras'' Theorem and Irrational Numbers';
chapter_name[2,11]:='Areas and Volumes (II)';
chapter_name[2,12]:='Trigonometric Ratios';
chapter_name[3,1]:='More about Factorization of Polynomials';
chapter_name[3,2]:='Linear Inequalities in One Unknown';
chapter_name[3,3]:='Percentages (II)';
chapter_name[3,4]:='Special Lines and Centres in a Triangle';
chapter_name[3,5]:='Quadrilaterals';
chapter_name[3,6]:='More about 3-D Figures';
chapter_name[3,7]:='Areas and Volumes (III)';
chapter_name[3,8]:='Coordinate Geometry of Straight Lines';
chapter_name[3,9]:='Trigonometric Relations';
chapter_name[3,10]:='Applications of Trigonometry';
chapter_name[3,11]:='Measures of Central Tendency';
chapter_name[3,12]:='Introduction to Probability';
chapter_name[4,1]:='Quadratic Equations in One Unknown (I)';
chapter_name[4,2]:='Quadratic Equations in One Unknown (II)';
chapter_name[4,3]:='Functions and Graphs';
chapter_name[4,4]:='Equations of Straight Lines';
chapter_name[4,5]:='More about Polynomials';
chapter_name[4,6]:='Exponential Functions \NF';
chapter_name[4,7]:='Logarithmic Functions \NF';
chapter_name[4,8]:='More about Equations \NF';
chapter_name[4,9]:='Variations';
chapter_name[4,10]:='More about Trigonometry';
chapter_name[5,1]:='Basic Properties of Circles';
chapter_name[5,2]:='Tangents to Circles \NF';
chapter_name[5,3]:='Inequalities';
chapter_name[5,4]:='Linear Programming \NF';
chapter_name[5,5]:='Applications of Trigonometry in 2-D problems \NF';
chapter_name[5,6]:='Applications of Trigonometry in 3-D problems \NF';
chapter_name[5,7]:='Equations of Circles';
chapter_name[5,8]:='Locus';
chapter_name[5,9]:='Measures of Dispersion';
chapter_name[5,10]:='Permutation and Combination \NF';
chapter_name[5,11]:='More about Probability \NF';
chapter_name[6,1]:='Arithmetic and Geometric Sequences';
chapter_name[6,2]:='Summation of Arithmetic and Geometric Sequences \NF';
chapter_name[6,3]:='More about Graphs of Functions';
chapter_name[6,4]:='Uses and Abuses of Statistics';
chapter_name[1,0]:='Basic Mathematics';

section_name[8,1,1]:='Surds';
section_name[8,1,2]:='Rationalization of Denominators';
section_name[8,2,1]:='Principle of Mathematical Induction';
section_name[8,2,2]:='Proofs of Propositions Involving Summation of Finite Sequences';
section_name[8,3,1]:='Factorial and Combination';
section_name[8,3,2]:='Summation Notation';
section_name[8,3,3]:='Binomial Theorem';
section_name[8,4,1]:='Radian Measure';
section_name[8,4,2]:='Trigonometric Ratios of Any Angle';
section_name[8,4,3]:='Conversion Formulae of Trigonometric Ratios';
section_name[8,4,4]:='Graphs and Properties of Trigonometric Functions';
section_name[8,5,1]:='Compound Angle Formulae';
section_name[8,5,2]:='Double Angle Formulae';
section_name[8,5,3]:='Sum and Product Formulae';
section_name[8,6,1]:='Concept of Limits';
section_name[8,6,2]:='Limits of Functions';
section_name[8,6,3]:='Limits of Trigonometric Functions';
section_name[8,6,4]:='Limits at Infinity';
section_name[8,6,5]:='Number $e$, Exponential Function $e^x$ and Natural Logarithmic Function ln $x$';
section_name[8,7,1]:='Derivatives';
section_name[8,7,2]:='Differentiation Rules';
section_name[8,7,3]:='Differentiation of Composite Functions';
section_name[8,7,4]:='Implicit Differentiation';
section_name[8,7,5]:='Differentiation of Trigonometric Functions';
section_name[8,7,6]:='Differentiation of Exponential Functions and Logarithmic Functions';
section_name[8,7,7]:='Second Derivatives';
section_name[8,8,1]:='Tangents and Normals';
section_name[8,8,2]:='Local Extrema';
section_name[8,8,3]:='Concavity and Points of Inflexion';
section_name[8,8,4]:='Asymptotes';
section_name[8,8,5]:='Curve Sketching';
section_name[8,8,6]:='Global Extrema';
section_name[8,8,7]:='Applications of Global Extrema';
section_name[8,8,8]:='Rates of Change';
section_name[8,9,1]:='Indefinite Integration';
section_name[8,9,2]:='Integration Formulae';
section_name[8,9,3]:='Integration by Substitution';
section_name[8,9,4]:='Integration by Parts';
section_name[8,9,5]:='Indefinite Integration of Trigonometric Functions';
section_name[8,9,6]:='Finding Indefinite Integrals by Trigonometric Substitution';
section_name[8,9,7]:='Application of Indefinite Integrals';
section_name[8,10,1]:='Definite Integral';
section_name[8,10,2]:='Fundamental Theorem of Calculus';
section_name[8,10,3]:='Integration by Substitution';
section_name[8,10,4]:='Integration by Parts';
section_name[8,10,5]:='Definite Integration of Even, Odd and Periodic Functions';
section_name[8,11,1]:='Areas of Plane Figures';
section_name[8,11,2]:='Volumes of Solids of Revolution';
section_name[8,12,1]:='Matrices';
section_name[8,12,2]:='Operation of Matrices';
section_name[8,12,3]:='Definition of Determinants';
section_name[8,12,4]:='Properties of Determinants';
section_name[8,12,5]:='Inverses of Square Matrices';
section_name[8,12,6]:='Computation of Inverse Matrices';
section_name[8,13,1]:='Systems of Linear Equations';
section_name[8,13,2]:='Solving Systems of Linear Equations by Inverse Matrices';
section_name[8,13,3]:='Solving Systems of Linear Equations by Cramer''s Rule';
section_name[8,13,4]:='Solving Systems of Linear Equations by Gaussian Elimination';
section_name[8,13,5]:='Systems of Homogeneous Linear Equations';
section_name[8,14,1]:='Concept of Vectors';
section_name[8,14,2]:='Basic Operations of Vectors';
section_name[8,14,3]:='Representation of Vectors on the Two-dimensional Rectangular Coordinate Plane';
section_name[8,14,4]:='Representation of Vectors in the Three-dimensional Rectangular Coordinate System';
section_name[8,14,5]:='Division of a Line Segment';
section_name[8,15,1]:='Scalar Product';
section_name[8,15,2]:='Vector Product';
section_name[8,15,3]:='Scalar Triple Product';
section_name[1,0,1]:='Fundamental Arithmetic';
section_name[1,0,2]:='Multiples and Factors';
section_name[1,0,3]:='Fractions and Decimals';
section_name[1,0,4]:='Arithmetic Operations of Fractions';
section_name[1,1,1]:='Concept of Directed Numbers';
section_name[1,1,2]:='Addition and Subtraction of Directed Numbers';
section_name[1,1,3]:='Multiplication and Division of Directed Numbers';
section_name[1,1,4]:='Mixed Operations of Directed Numbers';
section_name[1,2,1]:='Algebra Language';
section_name[1,2,2]:='Formulas and Method of Substitution';
section_name[1,2,3]:='Number Patterns';
section_name[1,3,1]:='Algebraic Equations in One Unknown';
section_name[1,3,2]:='More about Solving Equations';
section_name[1,3,3]:='Applications of Algebraic Equations in One Unknown';
section_name[1,4,1]:='Simple Problems on Percentages';
section_name[1,4,2]:='Percentage Change';
section_name[1,4,3]:='Profit and Loss';
section_name[1,4,4]:='Discount';
section_name[1,5,1]:='Introduction to Estimation';
section_name[1,5,2]:='Estimation in Measurement';
section_name[1,6,1]:='Basic Elements of Geometry';
section_name[1,6,2]:='Plane Figures';
section_name[1,6,3]:='Construction of Geometric Figures';
section_name[1,6,4]:='Three-Dimensional Figures';
section_name[1,7,1]:='Symmetry';
section_name[1,7,2]:='Transformation';
section_name[1,8,1]:='Areas of Simple Polygons';
section_name[1,8,2]:='Volumes and Total Surface Areas of Prisms';
section_name[1,9,1]:='Concept of Congruence';
section_name[1,9,2]:='Conditions for Congruent Triangles';
section_name[1,9,3]:='Concept of Similarity';
section_name[1,9,4]:='Conditions for Similar Triangles';
section_name[1,10,1]:='Introduction to Ordered Pairs';
section_name[1,10,2]:='Rectangular Coordinate System';
section_name[1,10,3]:='Distance between Two Points';
section_name[1,10,4]:='Areas of Plane Figures';
section_name[1,10,5]:='Transformations of Points on the Coordinate Plane';
section_name[1,10,6]:='Polar Coordinate System';
section_name[1,11,1]:='Angles related to Intersecting Lines';
section_name[1,11,2]:='Angles related to Parallel Lines';
section_name[1,11,3]:='Identifying Parallel Lines';
section_name[1,12,1]:='Laws of Positive Integral Indices';
section_name[1,12,2]:='Polynomials';
section_name[1,12,3]:='Addition and Subtraction of Polynomials';
section_name[1,12,4]:='Multiplication of Polynomials';
section_name[1,13,1]:='Introduction to Various Stages of Statistics';
section_name[1,13,2]:='Construction and Interpretation of Simple Statistical Diagrams';
section_name[1,13,3]:='Construction and Interpretation of Stem-and-Leaf Diagrams';
section_name[1,13,4]:='Construction and Interpretation of Scattered Diagrams';
section_name[1,13,5]:='Constructing Statistical Diagrams with Computer Software';
section_name[2,1,1]:='Rates';
section_name[2,1,2]:='Ratios';
section_name[2,1,3]:='Applications of Ratios';
section_name[2,2,1]:='Meaning of Identities';
section_name[2,2,2]:='Some Important Algebraic Identities';
section_name[2,2,3]:='Factorization of Simple Algebraic Expressions';
section_name[2,3,1]:='Manipulation of Simple Algebraic Fractions';
section_name[2,3,2]:='Formulas and Substitution';
section_name[2,3,3]:='Change of Subject';
section_name[2,4,1]:='Significant Figures';
section_name[2,4,2]:='Errors';
section_name[2,5,1]:='Angles of a Triangle';
section_name[2,5,2]:='Isosceles Triangles and Equilateral Triangles';
section_name[2,5,3]:='Angles of a Polygon';
section_name[2,5,4]:='Tessellation';
section_name[2,6,1]:='Histograms';
section_name[2,6,2]:='Frequency Polygons and Curves';
section_name[2,6,3]:='Cumulative Frequency Polygons and Curves';
section_name[2,6,4]:='Choosing an Appropriate Diagram to Present Data';
section_name[2,6,5]:='Abuses of Statistical Diagrams';
section_name[2,7,1]:='Linear Equations in Two Unknowns and their Graphs';
section_name[2,7,2]:='Solving Simultaneous Linear Equations in Two Unknowns by the Graphical Method';
section_name[2,7,3]:='Solving Simultaneous Linear Equations in Two Unknowns by Algebraic Methods';
section_name[2,7,4]:='Applications of Simultaneous Linear Equations in Two Unknowns ';
section_name[2,8,1]:='Laws of Positive Integral Indices';
section_name[2,8,2]:='Zero and Negative Integral Indices';
section_name[2,8,3]:='Scientific Notation';
section_name[2,8,4]:='Different Numeral Systems \NF';
section_name[2,9,1]:='Deductive Geometry';
section_name[2,9,2]:='Deductive Proofs about Angles related to Lines and Triangles';
section_name[2,9,3]:='Deductive Proofs about Congruent Triangles and Isosceles Triangles';
section_name[2,9,4]:='Deductive Proofs about Similar Triangles';
section_name[2,9,5]:='Geometric Construction Using Compasses and A Straight Edge \NF';
section_name[2,10,1]:='Square Roots and Surds';
section_name[2,10,2]:='Pythagoras'' Theorem and its Proofs';
section_name[2,10,3]:='Converse of Pythagoras'' Theorem';
section_name[2,10,4]:='Applications of Pythagoras'' Theorem and its Converse';
section_name[2,10,5]:='Rational Numbers and Irrational Numbers';
section_name[2,10,6]:='Manipulations of Surds \NF';
section_name[2,11,1]:='Circumferences and Areas of Circles';
section_name[2,11,2]:='Lengths of Arcs and Areas of Sectors';
section_name[2,11,3]:='Cylinders';
section_name[2,12,1]:='Introduction to Trigonometric Ratios';
section_name[2,12,2]:='Sine Ratio';
section_name[2,12,3]:='Cosine Ratio';
section_name[2,12,4]:='Tangent Ratio';
section_name[2,12,5]:='Simple Applications of Trigonometric Ratios';
section_name[3,1,1]:='Factorization by Cross-method';
section_name[3,1,2]:='Sum and Difference of Two  Cubes \NF';
section_name[3,2,1]:='Concepts of Inequalities';
section_name[3,2,2]:='Basic Properties of Inequalities';
section_name[3,2,3]:='Linear Inequalities in One Unknown';
section_name[3,3,1]:='More about Percentage Changes';
section_name[3,3,2]:='Increase or Decrease at a Constant Rate';
section_name[3,3,3]:='Interest';
section_name[3,3,4]:='Taxation ';
section_name[3,4,1]:='Special Lines in a Triangle';
section_name[3,4,2]:='Centres of a Triangle \NF';
section_name[3,4,3]:='Triangle Inequality \NF';
section_name[3,5,1]:='Basic Terms of a Quadrilateral';
section_name[3,5,2]:='Parallelograms';
section_name[3,5,3]:='Properties of Some Other Special Quadrilaterals';
section_name[3,5,4]:='Geometric Proofs Related  to Parallelograms  \NF';
section_name[3,5,5]:='Mid-point Theorem and Intercept Theorem  \NF';
section_name[3,6,1]:='Symmetries of Solids';
section_name[3,6,2]:='Nets of Solids';
section_name[3,6,3]:='2-D Representations of Solids';
section_name[3,6,4]:='Points, Lines and Planes in Solids';
section_name[3,7,1]:='Pyramids';
section_name[3,7,2]:='Circular Cones';
section_name[3,7,3]:='Frustums';
section_name[3,7,4]:='Spheres';
section_name[3,7,5]:='Formulas for Lengths, Areas and Volumes';
section_name[3,7,6]:='Similar Shapes';
section_name[3,8,1]:='Distance between Any Two Points on a Plane';
section_name[3,8,2]:='Slope of a Straight Line';
section_name[3,8,3]:='Parallel and Perpendicular Lines';
section_name[3,8,4]:='Point of Division';
section_name[3,8,5]:='Using Analytic Approach to Prove Results Relating to Rectilinear Figures \NF';
section_name[3,9,1]:='Trigonometric Ratios of Special Angles';
section_name[3,9,2]:='Finding Trigonometric Ratios by Constructing Right-Angled Triangles';
section_name[3,9,3]:='Trigonometric Identities';
section_name[3,10,1]:='Gradient and Inclination';
section_name[3,10,2]:='Angles of Elevation and Depression';
section_name[3,10,3]:='Bearings';
section_name[3,10,4]:='Applications of Trigonometry to Rectilinear Figures';
section_name[3,11,1]:='Introduction to Central Tendency ';
section_name[3,11,2]:='Means';
section_name[3,11,3]:='Medians';
section_name[3,11,4]:='Modes and Modal Classes';
section_name[3,11,5]:='More about Means, Medians and Modes';
section_name[3,11,6]:='Misuses of Averages';
section_name[3,11,7]:='Effects of Data Change on Measures of Central Tendency \NF';
section_name[3,11,8]:='Weighted Mean';
section_name[3,12,1]:='Concepts of Probability ';
section_name[3,12,2]:='Further Problems on Probability';
section_name[3,12,3]:='Experimental Probability';
section_name[3,12,4]:='Expected Value';
section_name[4,1,1]:='Real Number System';
section_name[4,1,2]:='Solving Quadratic Equations by the Factor Method';
section_name[4,1,3]:='Solving Quadratic Equations by the Quadratic Formula';
section_name[4,1,4]:='Solving Quadratic Equations by the Graphical Method';
section_name[4,1,5]:='Problems Leading to Quadratic Equations';
section_name[4,2,1]:='Nature of Roots of a Quadratic Equation ';
section_name[4,2,2]:='Forming a Quadratic Equation with Given Roots';
section_name[4,2,3]:='Relations between Roots and Coefficients \NF';
section_name[4,2,4]:='Complex Number System (partly \NF)';
section_name[4,3,1]:='Introduction to Functions ';
section_name[4,3,2]:='Notation of a Function ';
section_name[4,3,3]:='Some Common Functions and their Graphs';
section_name[4,3,4]:='Optimum Values of Quadratic Functions (partly \NF)';
section_name[4,4,1]:='Equations of Straight Lines';
section_name[4,4,2]:='General Form of Equation of a Straight Line';
section_name[4,4,3]:='Possible Intersection of Straight Lines';
section_name[4,5,1]:='Revision on Polynomials ';
section_name[4,5,2]:='Division of Polynomials';
section_name[4,5,3]:='Remainder Theorem';
section_name[4,5,4]:='Factor Theorem';
section_name[4,5,5]:='H.C.F. and L.C.M. of Polynomials \NF';
section_name[4,5,6]:='Rational Functions and their Manipulations \NF';
section_name[4,6,1]:='Laws of Rational Indices \NF';
section_name[4,6,2]:='Exponential Equations \NF';
section_name[4,6,3]:='Exponential Functions and their Graphs \NF';
section_name[4,7,1]:='Common Logarithms \NF';
section_name[4,7,2]:='Applications of Common Logarithms \NF';
section_name[4,7,3]:='Logarithms to an Arbitrary Base \NF';
section_name[4,7,4]:='Graphs of Logarithmic Functions and their Features \NF';
section_name[4,7,5]:='Historical Development of the Concept of Logarithms \NF';
section_name[4,8,1]:='Solving Simultaneous Equations by the Algebraic Method  \NF';
section_name[4,8,2]:='Solving Simultaneous Equations by the Graphical Method \NF';
section_name[4,8,3]:='Equations Reducible to Quadratic Equations \NF';
section_name[4,8,4]:='Practical Problems Leading to Quadratic Equations \NF';
section_name[4,9,1]:='Basic Concept of Variation';
section_name[4,9,2]:='Direct Variation';
section_name[4,9,3]:='Inverse Variation';
section_name[4,9,4]:='Joint Variation';
section_name[4,9,5]:='Partial Variation';
section_name[4,10,1]:='Angles of Rotation ';
section_name[4,10,2]:='Trigonometric Ratios of Any Angle ';
section_name[4,10,3]:='Graphs of Trigonometric Functions';
section_name[4,10,4]:='Graphical Solutions of Trigonometric Equations';
section_name[4,10,5]:='Trigonometric Identities';
section_name[4,10,6]:='Solving Trigonometric Equations by Algebraic Methods';
section_name[5,1,1]:='Basic Terms of a Circle';
section_name[5,1,2]:='Chords of a Circle';
section_name[5,1,3]:='Angles in a Circle';
section_name[5,1,4]:='Relationships among Arcs, Chords and Angles';
section_name[5,1,5]:='Cyclic Quadrilaterals';
section_name[5,1,6]:='Concyclic Points \NF';
section_name[5,2,1]:='Tangents to a Circle and their Properties \NF';
section_name[5,2,2]:='Tangents from an External Point \NF';
section_name[5,2,3]:='Angles in the Alternate Segment \NF';
section_name[5,3,1]:='Compound Linear Inequalities in One Unknown';
section_name[5,3,2]:='Solving Quadratic Inequalities in One Unknown by the Graphical Method';
section_name[5,3,3]:='Solving Quadratic Inequalities in One Unknown by the Algebraic Method \NF';
section_name[5,3,4]:='Problems Leading to Quadratic Inequalities in One Unknown';
section_name[5,4,1]:='Linear Inequalities in Two Unknowns \NF';
section_name[5,4,2]:='Solving Systems of Linear Inequalities in Two Unknowns Graphically \NF';
section_name[5,4,3]:='Linear Programming \NF';
section_name[5,4,4]:='Applications of Linear Programming \NF';
section_name[5,5,1]:='Area of a Triangle \NF';
section_name[5,5,2]:='The Sine Formula \NF';
section_name[5,5,3]:='The Cosine Formula \NF';
section_name[5,5,4]:='Trigonometric Problems in Two Dimensions \NF';
section_name[5,6,1]:='Basic Terminologies in 3-dimensional Problems \NF';
section_name[5,6,2]:='More Examples on 3-dimensional Problems \NF';
section_name[5,6,3]:='Practical 3-dimensional Problems \NF';
section_name[5,7,1]:='Equations of Circles';
section_name[5,7,2]:='More about Equations of Circles';
section_name[5,7,3]:='Intersection between a  Straight Line and a Circle \NF';
section_name[5,8,1]:='Concept of a Locus';
section_name[5,8,2]:='Sketch and Description of a Locus';
section_name[5,8,3]:='Algebraic Equation of a Locus';
section_name[5,9,1]:='Introduction to Measures of Dispersion';
section_name[5,9,2]:='Range and Inter-quartile Range';
section_name[5,9,3]:='Box-and-Whisker Diagram';
section_name[5,9,4]:='Standard Deviation';
section_name[5,9,5]:='Comparing Dispersions Using Appropriate Measures';
section_name[5,9,6]:='Applications of Standard  Deviation \NF';
section_name[5,9,7]:='Effects of Data Change on  Measures of Dispersion \NF';
section_name[5,10,1]:='Basic Principles of Counting \NF';
section_name[5,10,2]:='Permutation \NF';
section_name[5,10,3]:='Combination \NF';
section_name[5,11,1]:='Set Language \NF';
section_name[5,11,2]:='Using Set Language in Probability \NF';
section_name[5,11,3]:='Addition Law of Probability \NF';
section_name[5,11,4]:='Multiplication Law of Probability for Independent Events \NF';
section_name[5,11,5]:='Conditional Probability and Multiplication Law of Probability for Dependent Events \NF';
section_name[5,11,6]:='Using Permutation and Combination to Solve Probability Problems \NF';
section_name[6,1,1]:='Review on Sequences';
section_name[6,1,2]:='Arithmetic Sequences \NF';
section_name[6,1,3]:='Geometric Sequences \NF';
section_name[6,1,4]:='Problems Involving  Arithmetic and Geometric  Sequences \NF';
section_name[6,2,1]:='Summation of a Sequence \NF';
section_name[6,2,2]:='Summation of an Arithmetic Sequence \NF';
section_name[6,2,3]:='Summation of a Geometric Sequence \NF';
section_name[6,2,4]:='Applications of the Summation of Arithmetic and Geometric Sequences \NF';
section_name[6,3,1]:='Graphs of Some Functions';
section_name[6,3,2]:='Solving Equations Using the Graphical Method';
section_name[6,3,3]:='Solving Inequalities Using the Graphical Method';
section_name[6,3,4]:='Transformations of Functions \NF';
section_name[6,4,1]:='Uses of Statistics';
section_name[6,4,2]:='Sampling Methods';
section_name[6,4,3]:='Data Collection Methods and Questionnaire Design';
section_name[6,4,4]:='Abuses of Statistics and Assessment of Statistical Investigations';

section_top[8,1]:=2;
section_top[8,2]:=2;
section_top[8,3]:=3;
section_top[8,4]:=4;
section_top[8,5]:=3;
section_top[8,6]:=5;
section_top[8,7]:=7;
section_top[8,8]:=8;
section_top[8,9]:=7;
section_top[8,10]:=5;
section_top[8,11]:=2;
section_top[8,12]:=6;
section_top[8,13]:=5;
section_top[8,14]:=5;
section_top[8,15]:=3;
section_top[1,1]:=4;
section_top[1,2]:=3;
section_top[1,3]:=3;
section_top[1,4]:=4;
section_top[1,5]:=2;
section_top[1,6]:=4;
section_top[1,7]:=2;
section_top[1,8]:=2;
section_top[1,9]:=4;
section_top[1,10]:=6;
section_top[1,11]:=3;
section_top[1,12]:=4;
section_top[1,13]:=5;
section_top[2,1]:=3;
section_top[2,2]:=3;
section_top[2,3]:=3;
section_top[2,4]:=2;
section_top[2,5]:=4;
section_top[2,6]:=5;
section_top[2,7]:=4;
section_top[2,8]:=4;
section_top[2,9]:=5;
section_top[2,10]:=6;
section_top[2,11]:=3;
section_top[2,12]:=5;
section_top[3,1]:=2;
section_top[3,2]:=3;
section_top[3,3]:=4;
section_top[3,4]:=3;
section_top[3,5]:=5;
section_top[3,6]:=4;
section_top[3,7]:=6;
section_top[3,8]:=5;
section_top[3,9]:=3;
section_top[3,10]:=4;
section_top[3,11]:=8;
section_top[3,12]:=4;
section_top[4,1]:=5;
section_top[4,2]:=4;
section_top[4,3]:=4;
section_top[4,4]:=3;
section_top[4,5]:=6;
section_top[4,6]:=3;
section_top[4,7]:=5;
section_top[4,8]:=4;
section_top[4,9]:=5;
section_top[4,10]:=6;
section_top[5,1]:=6;
section_top[5,2]:=3;
section_top[5,3]:=4;
section_top[5,4]:=4;
section_top[5,5]:=4;
section_top[5,6]:=3;
section_top[5,7]:=3;
section_top[5,8]:=3;
section_top[5,9]:=7;
section_top[5,10]:=3;
section_top[5,11]:=6;
section_top[6,1]:=4;
section_top[6,2]:=4;
section_top[6,3]:=4;
section_top[6,4]:=4;
section_top[1,0]:=4;

paper_shortcode[1]:='Sa';
paper_shortcode[2]:='Pr';
paper_shortcode[3]:='12';
paper_shortcode[4]:='13';
paper_shortcode[5]:='14';
paper_shortcode[6]:='15';
paper_shortcode[7]:='16';
paper_shortcode[8]:='17';
paper_shortcode[9]:='18';
paper_shortcode[10]:='19';
paper_shortcode[11]:='20';
paper_shortcode[12]:='21';
paper_shortcode[13]:='22';
paper_shortcode[14]:='23';
paper_shortcode[15]:='24';
paper_shortcode[16]:='25';

paper_code[1]:='DSE2012S';
paper_code[2]:='DSE2012P';
paper_code[3]:='DSE2012';
paper_code[4]:='DSE2013';
paper_code[5]:='DSE2014';
paper_code[6]:='DSE2015';
paper_code[7]:='DSE2016';
paper_code[8]:='DSE2017';
paper_code[9]:='DSE2018';
paper_code[10]:='DSE2019';
paper_code[11]:='DSE2020';
paper_code[12]:='DSE2021';
paper_code[13]:='DSE2022';
paper_code[14]:='DSE2023';
paper_code[15]:='DSE2024';
paper_code[16]:='DSE2025';

papertop:=16;

papersection_name[0]:='';
papersection_name[1]:='Paper 1 - A(1)';
papersection_name[2]:='Paper 1 - A(2)';
papersection_name[3]:='Paper 1 - B';
papersection_name[4]:='Paper 2 - A';
papersection_name[5]:='Paper 2 - B';
papersection_name[6]:='Cross Topic';
papersection_top:=6;


print_section_summary:=true;

Qtop:=0;
readln(n);
for i:=1 to n do
begin
	readln(tempstring);
	parse(tempstring);
end;

survey;

assign(output,'DSE-Stat.tex');
rewrite(output);
print_file_header;

// Overall Header
	writeln('\newpage');
	writeln('\thispagestyle{empty}');
	writeln('\setcounter{page}{1}');
	writeln('\rhead{Statistics on DSE Questions}');
	writeln('\lfoot{}');
	writeln('\begin{center}');
	writeln('Mathematics Revision Notes\\\vspace{1cm}');
	writeln('{\fontsize{24pt}{24pt}\selectfont {','Statistics on DSE Questions','}} \\\vspace{1cm}');
	writeln('\end{center}');
	writeln('\hline');

// Graph of S1 to S6
writeln('\section*{Mark Distribution from S1 to S6}');
graph_clear;
Graph_y_label:='Weight';
for i:=1 to syl_top do
begin
	graph_add_bar( syl[i] , Mark_Form[i]);
end;
graph_print;

graph_clear;
Graph_y_label:='Weight';
for i:=1 to syl_top do
begin
	graph_add_bar( syl[i] , Mark_Form_P1[i]);
end;
graph_print;

graph_clear;
Graph_y_label:='Weight';
for i:=1 to syl_top do
begin
	graph_add_bar( syl[i] , Mark_Form_P2[i]);
end;
graph_print;


	
for i:=1 to syl_top do
begin
	
	// Chapter List
	writeln('\newpage');
	writeln('\section*{', syl[i] ,' Chapters}');
	print_Chapter_List(i);

	// Graph of Chapter and Weight
	writeln('\section*{Mark Distribution from Chapter 1 to Chapter ',chapter_top[i],'}');
	graph_clear;
	Graph_y_label:='Weight';
	for j:=1 to chapter_top[i] do
	begin
		graph_add_bar( 'Ch '+ tostring(j),  Mark_Chapter[i,j] );
	end;
	graph_print;
	
end;







for i:=1 to syl_top do
begin
	
	// Form Header
	writeln('\newpage');
	print_Form_Header(i);

	// Chapter List
	writeln('\section*{Chapter List}');
	print_Chapter_List(i);
	
	// Graph of Chapter and Weight
	writeln('\section*{Mark Distribution from Chapter 1 to Chapter ',chapter_top[i],'}');
	graph_clear;
	Graph_y_label:='Weight';
	for j:=1 to chapter_top[i] do
	begin
		graph_add_bar( 'Ch '+ tostring(j),  Mark_Chapter[i,j] );
	end;
	graph_print;
	
	// Graph of Chapter and P1
	graph_clear;
	Graph_y_label:='P1 Marks';
	for j:=1 to chapter_top[i] do
	begin
		graph_add_bar( 'Ch '+ tostring(j),  Mark_Chapter_P1[i,j] );
	end;
	graph_print;
	
	// Graph of Chapter and P2
	graph_clear;
	Graph_y_label:='P2 Marks';
	for j:=1 to chapter_top[i] do
	begin
		graph_add_bar( 'Ch '+ tostring(j),  Mark_Chapter_P2[i,j] );
	end;
	graph_print;
	
		
	for j:=1 to chapter_top[i] do
	begin
	
		writeln('\newpage');
		print_chapter_header(i,j);
		
		// Section List
		writeln('\section*{Section List}');
		print_section_list(i,j);
		
		// P1 Table
		writeln('\begin{absolutelynopagebreak}');
		writeln('\begin{center}');
		writeln('\textbf{DSE Core Paper 1}');
		writeln('\end{center}');
		print_section_P1_table(i,j);
		writeln('\end{absolutelynopagebreak}');
		
		// P2 Table
		writeln('\begin{absolutelynopagebreak}');
		writeln('\begin{center}');
		writeln('\textbf{DSE Core Paper 2}');
		writeln('\end{center}');
		print_section_P2_table(i,j);
		writeln('\end{absolutelynopagebreak}');
		
		// Question Table
		writeln('\begin{absolutelynopagebreak}');
		writeln('\begin{center}');
		writeln('\textbf{DSE Question Table}');
		writeln('\end{center}');
		print_chapter_question_table(i,j);
		writeln('\end{absolutelynopagebreak}');
		
	end;
	
end;
print_file_footer;
close(output);


////////////////////


for i:=1 to syl_top do
begin

	assign(output,'DSE-'+syl[i]+'.tex');
	rewrite(output);
	print_file_header;

	
	// Form Header
	writeln('\newpage');
	print_Form_Header(i);

	// Chapter List
	writeln('\section*{Chapter List}');
	print_Chapter_List(i);
	
	// Graph of Chapter and Weight
	writeln('\section*{Mark Distribution from Chapter 1 to Chapter ',chapter_top[i],'}');
	graph_clear;
	Graph_y_label:='Weight';
	for j:=1 to chapter_top[i] do
	begin
		graph_add_bar( 'Ch '+ tostring(j),  Mark_Chapter[i,j] );
	end;
	graph_print;
	
	// Graph of Chapter and P1
	graph_clear;
	Graph_y_label:='P1 Marks';
	for j:=1 to chapter_top[i] do
	begin
		graph_add_bar( 'Ch '+ tostring(j),  Mark_Chapter_P1[i,j] );
	end;
	graph_print;
	
	// Graph of Chapter and P2
	graph_clear;
	Graph_y_label:='P2 Marks';
	for j:=1 to chapter_top[i] do
	begin
		graph_add_bar( 'Ch '+ tostring(j),  Mark_Chapter_P2[i,j] );
	end;
	graph_print;
	
		
	for j:=1 to chapter_top[i] do
	begin
	
		writeln('\newpage');
		print_chapter_header(i,j);
		
		// Section List
		writeln('\section*{Section List}');
		print_section_list(i,j);
		
		// P1 Table
		writeln('\begin{absolutelynopagebreak}');
		writeln('\begin{center}');
		writeln('\textbf{DSE Core Paper 1}');
		writeln('\end{center}');
		print_section_P1_table(i,j);
		writeln('\end{absolutelynopagebreak}');
		
		// P2 Table
		writeln('\begin{absolutelynopagebreak}');
		writeln('\begin{center}');
		writeln('\textbf{DSE Core Paper 2}');
		writeln('\end{center}');
		print_section_P2_table(i,j);
		writeln('\end{absolutelynopagebreak}');
		
		// Question Table
		writeln('\begin{absolutelynopagebreak}');
		writeln('\begin{center}');
		writeln('\textbf{DSE Question Table}');
		writeln('\end{center}');
		print_chapter_question_table(i,j);
		writeln('\end{absolutelynopagebreak}');
		
		
		printquestions(i,j);
			
		
	end;
	
	
	
	print_file_footer;
	close(output);

end;



End.












procedure previous;
begin



	for j:=1 to chapter_top[i] do
	begin
		//Chapter Header
		print_chapter_header(i,j);
		
		
		////Overview
				
			//Section List
			writeln('\section*{Section List}');
			print_section_list(i,j);
			
			//Section-Mark Table
				//P1
				
				//P2
			
			//Question List
		

		////Content
			for k:=1 to section_top[i,j] do
			begin
				//Section
				
				//Section Summary
				
				for p:= 1 to papersection_top do
				begin
					//Question
				
				end;
				
			
			end;
		
		
		////Appendix
			// Reference
			
			
			// Answers
			
			
			
			
	end;




/////////////////////////////////////////////////


for i:=1 to syl_top do
begin

	for j:=1 to chapter_top[i] do
	begin
		weight[i,j]:=0;
	end;
	for t:=1 to Qtop do
	begin
		if (Q_Syl_num[t]=i) then
		begin
			inc(weight[i,Q_Ch_num[t]],Q_Mark[t]);
		end;
	end;

	assign(Fx,'pre_'+syl[i]+'.out');
	rewrite(Fx);
	
	writeln(Fx,'\newpage');
	writeln(Fx,'\thispagestyle{empty}');
	writeln(Fx,'\setcounter{page}{1}');
	writeln(Fx,'\rhead{Statistics on S',i,' Chapters}');
	writeln(Fx,'\lfoot{S',i,' Chapters}');
	writeln(Fx,'\begin{center}');
	writeln(Fx,'Mathematics Revision Notes\\\vspace{1cm}');
	writeln(Fx,'\greybox{\fontsize{24pt}{24pt}\selectfont {S',i,' Chapters}} \\\vspace{1cm}');
	writeln(Fx,'');
	writeln(Fx,'\end{center}');
	writeln(Fx,'\vspace{0.5cm}');
	writeln(Fx,'\hline');

	writeln(Fx,'\section*{Chapter List}');
	
	writeln(Fx,'\begin{enumx}[label=Ch \arabic*.]');
	for j:= 1 to chapter_top[i] do
	begin
		writeln(Fx,'\item ',chapter_name[i,j]);
	end;
	writeln(Fx,'\end{enumx}');

	writeln(Fx,'\begin{center}');
	writeln(Fx,'\begin{tikzpicture}');
	writeln(Fx,'  \begin{axis}[');
	writeln(Fx,'	width=18cm,');
	writeln(Fx,'	height=8cm,');
	writeln(Fx,'bar width =0.6cm,');
	writeln(Fx,'ybar,');
	writeln(Fx,'ylabel={Weight},');
	writeln(Fx,'xticklabels={');
	for j:= 1 to chapter_top[i] do
	begin
		write(Fx,'Ch ',j);
		if (j<chapter_top[i]) then write(Fx,',');
	end;
	writeln(Fx,'},');
	writeln(Fx,'xtick=data,');
	writeln(Fx,'ymin=0,');
	writeln(Fx,'nodes near coords,');
	writeln(Fx,'nodes near coords align={vertical},');
	writeln(Fx,'x tick label style={rotate=45,anchor=east},');
	writeln(Fx,']');
	write(Fx,'\addplot coordinates {');
	for j:= 1 to chapter_top[i] do
	begin
		write(Fx,'(',j,',',weight[i,j],')');
	end;
	writeln(Fx,'};');
	writeln(Fx,'\end{axis}');
	writeln(Fx,'\end{tikzpicture}');
	writeln(Fx,'\end{center}');

	

	
	
	
	
	assign(output,syl[i]+'.out');
	rewrite(output);
	
	writeln;
	writeln;
	writeln;
	writeln;
	writeln;
	writeln('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
	writeln('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
	writeln('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
	writeln('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
	writeln;
			
	writeln('%',syl[i]);

	
	for j:= 1 to chapter_top[i] do
	begin
		writeln;
		writeln;
		writeln;
		writeln;
		writeln('%',j,' ',chapter_name[i,j]);
		new_chapter_header(i,j);
		
		section_list(i,j);
		
		printsectionsummary(i,j);
				
		printstat(i,j);
		printlist(i,j);

	end;

	close(output);
	close(Fx);
	
end;

end;










