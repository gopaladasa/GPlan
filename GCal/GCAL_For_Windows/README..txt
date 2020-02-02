Versions of Gaurabda Calendar program
 

Development of this application started in 2006.

 

History:

2006 – basic discussion about program

2007 – looking for algorithms and user interface

2008 – beta testing

2009 - full release (version 5.0)

 

GCAL 0.0 (GCAL 0)
(Previously with another name)

RELEASE DATE:

- initial version in non-resizeable dialog window

GCAL 1.0
RELEASE DATE: 28-Sep-2007

- unified behaviour for naksatra, tithi and sankranti dialog

- fixed bug for tithi calculation

- select & copy from text in main window

- implemented ekadasi parana calculation according last specification

- writes location for calendar calculations

- calculates celebration dates for future years for appearance day calc.

- changed Compare tool

- export to external file also to TEXT file

GCAL 1.1
RELEASE DATE: 18-Dec-2007

- windows are resizeable

- added introductional page "Today" with information about today's vaisnava day. Location for Today calculation are set in menu "Settings / My Location"

- changed user interface

GCAL 1.1.6
RELEASE DATE: 4-Feb-2008

- little improved textual output

- all changes mentioned in beta-testing results

- changed "Select Location" dialog window

GCAL 1.1.7
RELEASE DATE: 7-Feb-2008

- corrected dialog window for location is attached.

New functions:

- add new location

- edit location

- remove location

- reset to build-in list of locations

- locations dialog available in menu Settings->Locations

- storing of location list (changes in loc.list are persistent)

GCAL 1.1.8
RELEASE DATE: 10-Feb-2008

- fixed bug in My Location dialog window

GCAL 1.1.9
RELEASE DATE: 18-Feb-2008

- added command-line arguments

GCAL 1.1.10
RELEASE DATE: 19-Apr-2008

- added underline for menu items

- corrected correction of Ekadasi Parana time according DST

- corrected calculation of initial TODAY page

- updated (no) DST for Arizona, Puerto Rico and Hawaii: set for not used

- corrected TIMEZONE parameter for console mode

 

GCAL 1.1.11
RELEASE DATE: 21-Apr-2008

- added choice for ayanamsa value (Fagan/Lahiri/Krishnamurti/Raman)

- corrected calculation of moonrise/moonset

- corrected printing of DST note in calendar listing

 

GCAL 1.2.0
RELEASE DATE: 2-MAY-2008

- added calculation "Next Tithi" and "Prev Tithi" for keys F5 and F7, active, when window contains result of calculation of tithi times

- custom defined events

- added show setting items: - Month header, Dont show empty days, Show begining of Masa

- added new locations: total count is 2381 cities

- new names for DST according international standard

- corrected ekadasi parana for unmilani dvadasi

 

GCAL 1.2.1
RELEASE DATE: 8-MAY-2008

- corrected using of custom event (used immediately after creation)

- editing of custom event

- limited length for custom event description text to 39 chars

- saving of settings for shown info

- corrected ksaya tithi listing

- corrected "Asia/Urunqi" to "China"

- fixed bug in Settings/Location/Create Location and Edit and Export Location

- removed blank lines in calendar listing

- added hidden choice for setting Ayanamsa and Sankranti (CTRL+SHIFT+F11)

- storage of configuration files in separate subdirectory "config"

 

GCAL 1.2.2
RELEASE DATE: 28-MAY-2008

- changed ekadasi parana calculation for naksatra mahadvadasis

 

GCAL 1.2.3
RELEASE DATE: 30-MAY-2008

- fixed initialization of hour for staring date for calendar calculations

- increase of precision of algorithms: naksatra and tithi start calculation

- changed size of dialog window "Observed Events"

- correction of exporting calendar results into file

- correction of running progress during calculation

- set limit of max 90 years for calendar calculation

- storing of default values for dialog windows for various calculations

- corrected printing of ksaya tithi time

- corrected printing of vriddhi info

 

GCAL 1.2.4
RELEASE DATE: 5-JUNE-2008

- removed "Save Content" from Edit menu

- fixed "Naksatra Mahadvadasi" bug

 

GCAL 1.2.5
RELEASE DATE: 7-JUNE-2008

- corrected handling of (ksaya/adhika) masa sequences

GCAL 1.2.6
RELEASE DATE: 10-JUNE-2008

- corrected calculation of sankrantis

- corrected print-out of tithi times

- default ayanamsa method is Krishnamurti

- changed layout for calculation of sankrantis

GCAL 1.2.7
RELEASE DATE: 19-JUNE-2008

- default ayanamsa set to Lahiri

- corrected appearance day calculation (crashing)

- corrected masa listing (strange dates)

GCAL 1.2.8 (GCAL 1)
RELEASE DATE: 22-JUNE-2008

- corrected today screen (error in showing of the information)

- corrected closing of multiple windows (in prev version when first opened window was closed, application terminated, now app will terminate only when last window is closed)

GCAL 1.3.0
RELEASE DATE: 1-SEPT-2008 (GCAL 1.1)

- corrected "Bengalooru" to "Bangalore" in Location List

- possibility to export calendar to iCalendar format (.ics file) and vCalendar format (.vcs)

- changed appearance of the Settings dialog

- added recalculation of calendar after setting ayanamsa/sankranti method

- added tithi calculation to naksatra screen and changed title to "Tithi & Naksatra List"

- changed choosing of country in the Create Country window + automatic updating of DST system according country + automatic updating of TimeZone offset according selected DST system

- introduced classes for events (0 for Appearance days of the Lord, ... 6 for Custom Events)

- improved Find Event dialog window ... 3 conditions for a day + more values

- printing capability for all outputs, special output for Calendar and Tithi and Naksatra List

- corrected DST adding to sankranti time

- renamed "Tithi Timing" to "Day Inspector" + improved layout

- changed dialog window "Day Inspector" – ability to insert Gregorian date simultaneously with Gaurabda date

- possibility to show location in Google Maps

GCAL 1.3.1 (GCAL 2)
RELEASE DATE: 8-SEPT-2008
EXPIRATION DATE: 15-DEC-2008

- corrected freezing in „Day Inspector“ dialog window

- added scroll-box to "All Results"-tab in the Event Finder window

- changed "colon separated value" to "comma separated value"

GCAL 2.1
ALFA RELEASE DATE: 30-OCT-2008 (GCAL 2.1)

- main window remembers its position on screen between launching application

- corrected behaviour in EditLocation dialog window - enabling of OK button, when manualy typing the name of country

- corrected behaviour in GetLocation and EditLocation dialog windows - not changing selection in Timezone combobox

- improved behaviour in GetLocation and EditLocation dialog windows - DST combobox contains only DST systems valid for selected Timezone (that means there are not so many irrelevant choices in DST combobox)

- corrected display of Today information when sankranti occurs

- changed command line structure (see document "GCal Command Line using.doc")

- added possibility to save Appearance Day calculation results in the XML format

- merge of "Day Inspector", "Sankranti" and "Tithi&Naksatra List" into one screen - "Core Events"

- restructured dialog windows for calculation inputs

GCAL 2.2
ALFA RELEASE DATE: 5-NOV-2008 (GCAL 2.2)

- corrected calculation of Core Events and Appearance Day

GCAL 2.3
ALFA RELEASE DATE: 20-NOV-2008 (GCAL 2.3)

- corrected writing of the XML file format for Appearance Day data

GCAL 3
RELEASE DATE: 9-DEC-2008
EXPIRATION DATE: 15-MAR-2009

- added writing of calendar results in HTML table format, setting of first day in week is in the Calendar Display Settings / Advanced.

- corrected closing of the application by command 'Exit" in the main menu

- in Today screen, showing sunset, noon and sunrise time

- for Calendar display is now showing of paksa, naksatra, yoga and fasting flag made optional (settings are available at the "Festivals" pane in the Calendar Display Settings)

- added printing of the change of the DST system (transition from local time to DST and back), optional setting is available at the "Advanced" pane in the Calendar Display Settings

- corrected fasting data for Advaita Acarya Appearance Day

- corrected bug in Calendar Display Settings Window (was not saving settings when changing tabs)

GCAL 3.1
- corrected Australia/Sydney time zone

- added possibility to save HTML for calendar results, core events result and appearance day results

GCAL 3.2
- added latitude and longitude to the Today Screen

- changed selecting of timezone and DST -> only one combo box for timezone

GCAL 4
RELEASE DATE: 12-MAR-2009
EXPIRATION DATE: 15-JULY-2009

- added windows Event Manager and Locations Manager

- when data for location (name, coordinates, etc.) were changed in Location Manager and that location is identical with My Location, or location which was previously selected for calculation, then these locations (My Loc or previous loc) are corrected too

GCAL 4.1
- changed layout for Location manager

- added possibility to add or rename country

- added String Manager - for editing strings used for output

- corrected Timezone for Pacific/Auckland and Pacific/Chatham

- corrected bug related to calculation of Core Events (when applied start of month was different when applied start of gaurabda year), reason was wrong setting of timezone when applying move in time in dialog "Get Start Date"

- added possibility to show results in Normal View (plain text) or Enhanced View (rich text), also added possibility to change the size of text for Enhanced View

- added Moon Rasi information into calendar output

GCAL 4.2
- added check box for old style fasting

- corrected show in the month header mode

- changed text for ksaya tithi info

- disabled default events, enabling is possible in expert mode

GCAL 4.3
- user interface corrections

GCAL 4.4
- Today's Tip feature added

GCAL 4.5
- correction of timezone for Pacific/Auckland - actually correction of this timezone in version 4.1 was not complete, calendar was still showing differences (showing another timezone that calculating) it was because in 4.1 was changed only name of timezone, but in this version was changed

GCAL 5
RELEASE DATE: 15-JULY-2009
EXPIRATION DATE: NO
FULL PUBLIC RELEASE: YES

- added references to help file from main application

- removed time limitation

- removed "BETA" from the title of app

- added help file in CHM format (Windows Html Help format)

GCAL 5.01
- changed Rama Navami (Navami Tithi, Krsna paksa) to (Astami Tithi, Gaura paksa)

- enabled editing of Event Text but with limitation of 39 charaters

- corrected Import/Export in String Manager

GCAL 5.02
RELEASE DATE: 17-AUGUST-2009

- corrected Rama Navami (Astami Tithi) to (Navami Tithi)

- changed limit of text length for Event Text to 80 characters

GCAL 5.03
RELEASE DATE: 22-SEPTEMBER-2009

- corrected StartDate dialog window; BUG: when repeatedly used, TimeZone is updated only for first use of this dialog window, CORRECTION: TimeZone is updated for each show of this dialog window

- Correction: Tips of the Day is not showed when GCAL is running in console mode

- added info about day of week to the Today Screen

GCAL 5.04
RELEASE DATE: 23-SEPTEMBER-2009

- corrected text for Fasting info when festival occurs on Ekadasi; valid for two festivals: Gaurakisora das Babaji Disappearance and Sri Vamanadev Appearance

GCAL 5.05
RELEASE DATE: 13-OCTOBER-2009

- corrected loading of file for Countries

- reinitialization of damaged Location file

- currected behaviour of Select Location

GCAL 5.06
RELEASE DATE: 05-NOV-2009

- corrected text " Sri Krsna Pusya abhiseka" to "Sri Krsna Pusya Abhiseka"
- corrected initial coordinates for location in Today Screen, corrected to Vrindavan 27N35 77E42
- corrected feature Import Location List. Imported file was deleted after import. Now, imported file is left on storage medium as it is.
GCAL 5.07
RELEASE DATE: 18-NOV-2009

- corrected timezone for Chile: new value is -4:00 America/Santiago
GCAL 6
RELEASE DATE: 13-DEC-2009

- corrected Key Shortcuts in main window after setting focus to text window results.

- corrected all timezones for Australia

- allowed deleting personal events, corrected option to show only personal events

- corrected calculation fo ending date when start date falls within purushottama-adhika masa

- added info about day of week into Enhanced View of Today Screen

- added Find String function in String Manager

- added option to show Brahma Muhurta info in Today Screen

 

GCAL 7
RELEASE DATE: 9-MAR-2010

- corrected sankranti time when applied DST

- added locations to Locations DB: Manama (Bahrain), Vasco da Gamma (India)

- increased number of iterations for calculation of starting time of naksatras, tithis, sankrantis and conjunctions to 20 steps (from 15 steps) for better precision

- corrected "ARC" label to "MIN" in the Location dialog window; this is because we have DEGREES and MINUTES, not DEGREES and ARC SECONDS - this was confusing

GCAL 8
RELEASE DATE: 24-JUNE-2010

- corrected calculation of Srila Prabhupada Appearance Day - in some cases it was printed on the same day as Janmasthami

GCAL 9
RELEASE DATE: 8-OCT-2010

- added info (Naksatra Pada, Naksatra Elapsed, Rasi of the Moon) to the Today screen. Correcponding option checkboxes are in Settings / Calendar Display -- table Today, checkboxes "Rasi of the Moon" and "Naksatra Elapsed". Default setting is OFF, information is not visible.

- added info (Suggestions for child names) to the Appearance Day screen. Corresponding option checkbox is in Settings / Calendar Display -- table Astronomy, checkbox "Child Name Suggestion". Default setting is OFF, information is not visible.

GCAL 9.01
RELEASE DATE: 19-OCT-2010

- corrected names for children (according rasi)

- added moon rasi and sun rasi to the Appearance day screen

- removed note about "beta version" from "About dialog"

GCAL 10
RELEASE DATE: 15-DEC-2010

- Added configurable show of masa name. Corresponding list of possible options is in Settings / calendar Display – table General

Possible configurations masa name are:

-      Vaisnava

-      Vaisnava (Common)

-      Common

-      Common (Vaisnava)

- Added Kuwait City to the list of locations

GCAL 10.1
RELEASE DATE: 15-FEB-2010

- corrected printing of calendar (festivals were not shown)

- corrected export to CSV (option “Do not show empty days” was not working)

- corrected export to HTML (option “Do not show empty days” was not working)

 GCAL 10.2
RELEASE DATE: 15-APR-2010

- changed timezone of America/Sao_Paulo and America/Montevideo to -3:00 UTC

 GCAL 11
RELEASE DATE: 30-JUN-2011

- added ekadasi parana details in output for calendar (Settings->Calendar Display->Advanced->Ekadasi Parana details, default is off)

- added DST/LT note for Core Events screen

- corrected calculation of the first month of caturmasya for Purnima system

 GCAL 11, Build 2
RELEASE DATE: 10-AUG-2011

- corrected spelling for Pavitraropana Ekadashi

- corrected calculation of First day of the month for some specific situations


 GCAL 11, Build 3
RELEASE DATE: 19-DEC-2012

- corrected input of latitude and longitude

 GCAL 12, Beta version B
RELEASE DATE: 4-AUG-2013

- complete refactoring of application to .Net platform


 GCAL 11, Build 5
RELEASE DATE: 31 MAY 2019

- added Bhadra Purnima in Hrsikesha masa 

- remove Lalita Sasthi 

- Appearance of Radha kunda moved to Vishnu (Caitra) Masa


Wish List
- tithi, naksatra info in Today screen

- button "Stop" in calculation window

- history for calculations

- updating of Location database

- update of application/data via Internet

- sun/moon eclipse

- move application to the .NET platform (3.5 or higher)

 
