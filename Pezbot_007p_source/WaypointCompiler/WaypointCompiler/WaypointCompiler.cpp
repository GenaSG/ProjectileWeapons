// WaypointCompiler.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"
#include <stdio.h>
#include <io.h>
#include <time.h>



/////////////////////////////////////////////////////////////////////
// processes csv_file
/////////////////////////////////////////////////////////////////////
void ProcessCSV(FILE *pCompiledFile, const struct _finddata_t &csv_file, int *pCurrCompiledLine)
{
  FILE *pFile = fopen(csv_file.name, "r");

  char buf[1024];
  char buf2[1024];
  while(!feof(pFile))
  {
    fgets(buf, 1024, pFile);
    
    memcpy(buf2, buf, 1024);
    strtok(buf, ",");

    if(strstr(buf2, "end"))
    {
      fprintf(pCompiledFile, "%d%s,0,0\n",*pCurrCompiledLine, &buf2[strlen(buf)]);
    }
    else
    {
      fprintf(pCompiledFile, "%d%s",*pCurrCompiledLine, &buf2[strlen(buf)]);
    }
    (*pCurrCompiledLine)++;
  }

  fclose(pFile);
}

/////////////////////////////////////////////////////////////////////
// builds header of csv
/////////////////////////////////////////////////////////////////////
void BuildCSVHeader(FILE *pCompiledFile, const struct _finddata_t &csv_file, int *pCurrCompiledLine, int *pTotalWPCount)
{
  int iLineCount = 0;
  FILE *pFile = fopen(csv_file.name, "r");

  char buf[1024];
  while(!feof(pFile))
  {
    fgets(buf, 1024, pFile);
  }
  
  iLineCount = atoi(strtok(buf, ",end"));

  fprintf(pCompiledFile, "%d,%d,%d,%s\n",*pCurrCompiledLine, iLineCount, *pTotalWPCount, csv_file.name);
  (*pCurrCompiledLine)++;

  *pTotalWPCount += (iLineCount+1);

  fclose(pFile);
}

/////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////
void BuildCompiledCSVHeader(FILE *pCompiledFile, int *pCurrCompiledLine, int *pTotalWPCount)
{

  struct _finddata_t csv_file;
  long hFile;

  // Find first .csv file in current directory
  if((hFile = _findfirst("*.csv", &csv_file)) == -1L)
  {
      printf("No *.csv files in current directory!\n");
  }
  else
  {
    // Find the rest of the .csv files
    do
    {
      if(!strstr(csv_file.name, "PeZBOT_WP_"))
      {
        BuildCSVHeader(pCompiledFile, csv_file, pCurrCompiledLine, pTotalWPCount);
      }
    }
    while(_findnext(hFile, &csv_file) == 0);
    
    _findclose(hFile);
  }
}


/////////////////////////////////////////////////////////////////////
// 
/////////////////////////////////////////////////////////////////////
int CountCSVs()
{

  struct _finddata_t csv_file;
  long hFile;
  int iCount = 0;

  // Find first .csv file in current directory
  if((hFile = _findfirst("*.csv", &csv_file)) == -1L)
  {
      printf("No *.csv files in current directory!\n");
  }
  else
  {

    // Find the rest of the .csv files
    do
    {
      if(!strstr(csv_file.name, "PeZBOT_WP_"))
      {
        iCount++;
      }
    }
    while(_findnext(hFile, &csv_file) == 0);
    
    _findclose(hFile);
  }

  return iCount;
}



int _tmain(int argc, _TCHAR* argv[])
{

  int iCSVCount = CountCSVs();
  int iCurrCompiledLine = 0;
  int iTotalWPCount = iCSVCount+1;
  char compiledFilename[256];
  int iCompiledFileCount = 0;
  int iCompiledLineCount = 0;

  if(!iCSVCount)
  {
    return 0;
  }

  sprintf(compiledFilename, "PeZBOT_WP_%d.csv", iCompiledFileCount);

  FILE *pCompiledFile = fopen(compiledFilename, "w");

  //print number of csvs on first line
  fprintf(pCompiledFile, "%d,%d,0,0\n",iCurrCompiledLine++, iCSVCount);

  //build the header for the compiled csv
  BuildCompiledCSVHeader(pCompiledFile, &iCurrCompiledLine, &iTotalWPCount);


  struct _finddata_t csv_file;
  long hFile;

  // Find first .csv file in current directory
  if((hFile = _findfirst("*.csv", &csv_file)) == -1L)
  {
      printf("No *.csv files in current directory!\n");
  }
  else
  {

    //Find the .csv files
    do    
    {
/*
        printf( ( csv_file.attrib & _A_RDONLY ) ? " Y  " : " N  " );
        printf( ( csv_file.attrib & _A_SYSTEM ) ? " Y  " : " N  " );
        printf( ( csv_file.attrib & _A_HIDDEN ) ? " Y  " : " N  " );
        printf( ( csv_file.attrib & _A_ARCH )   ? " Y  " : " N  " );
        printf( " %-12s %.24s  %9ld\n",
            csv_file.name, ctime( &( csv_file.time_write ) ), csv_file.size );
*/
      if(!strstr(csv_file.name, "PeZBOT_WP_"))
      {
        if(iCompiledLineCount > 800)
        {
          iCompiledFileCount++;
          sprintf(compiledFilename, "PeZBOT_WP_%d.csv", iCompiledFileCount);
          fclose(pCompiledFile);
          pCompiledFile = fopen(compiledFilename, "w");
          iCompiledLineCount = 0;
        }
        int iOldCurrCompiledLine = iCurrCompiledLine;
        ProcessCSV(pCompiledFile, csv_file, &iCurrCompiledLine);
        iCompiledLineCount += iCurrCompiledLine-iOldCurrCompiledLine;
      }
    }
    while(_findnext(hFile, &csv_file) == 0);

    _findclose(hFile);

  }

  fclose(pCompiledFile);
	return 0;
}
