#!/bin/env wish
##########################################
# Docker Helper for Mobecls.com
# version 1.1 
# Чтв 12 сен 2019
##########################################
#
package require Tk
package require msgcat
namespace import msgcat::mc

namespace eval ::docker-helper {
    set currentTerminal ""
    set startDirectory ""
    set bottomLabel ""
    set mainList ""
    set inputVariable "local.domain.com"
    set sudoPassword ""
    set terminalAdditionCommands " && echo \"\n\n\" && echo 'Press Enter to close window...' && read d"

    #
    # prepare fonts
    # run UI creator
    #
    proc main {} {
	variable currentTerminal
	variable startDirectory
	
	set startDirectory [pwd]

        if {$::argc > 0} {
            set workingDir [lindex $::argv 0]
	} else {
	    if {![catch {glob -type f "rebuild.sh"} globError]} {
	        set workingDir "../"
	    } else {
		if {$::tcl_platform(osVersion) eq "4.19.0-5-amd64"} {
		    set workingDir /home/roman/work/docker/allmakes4x4/compose
		} else {
		    set workingDir /home/$::tcl_platform(user)/work/docker/velik/compose
		}
	    }
	}

	cd $workingDir

	if {[lsearch -exact [font names] TkDefaultFont] == -1} {
	    font create TkDefaultFont -family Helvetica -size 10
	}
	eval font create TkBoldFont [font actual TkDefaultFont] -weight bold

	if {[catch {open "/etc/alternatives/x-terminal-emulator" } x_terminal]} {
	    set currentTerminal xterm
	} else {
	    set currentTerminal /etc/alternatives/x-terminal-emulator 
	}

	# run main window 
	buildMainWin
    }

    #
    # create main window
    # 
    proc buildMainWin {} {
	variable bottomLabel 
	variable mainList 
	variable currentTerminal

	set mainMenu [menu .mbar]

	. configure -menu $mainMenu

	set mainFrame [frame .wmframe]
	pack $mainFrame -fill both -expand 1

	frame $mainFrame.pn
	pack $mainFrame.pn -fill both -expand 1

	set mainList [text $mainFrame.pn.text -relief raised -borderwidth 0 -highlightthickness 0 -wrap word]
        
        ttk::scrollbar $mainFrame.pn.vsb -orient vertical -command "$mainList yview"
        $mainList configure -yscrollcommand "$mainFrame.pn.vsb set"

	$mainList tag configure command -font TkBoldFont
	$mainList tag configure error   -font TkDefaultFont -foreground firebrick
	$mainList tag configure output  -font TkDefaultFont -foreground black

        grid $mainList $mainFrame.pn.vsb -sticky news
        grid rowconfigure $mainFrame.pn 0 -weight 1
        grid columnconfigure $mainFrame.pn 0 -weight 1	
	
	frame $mainFrame.comline -relief sunken -borderwidth 1 
	pack $mainFrame.comline -fill x -side bottom -pady 1

	set bottomLabel [label $mainFrame.comline.label -padx 0 -anchor w]
	pack $bottomLabel -fill x -padx 0

	menu $mainMenu.fl -tearoff 0

	set openProject [menu $mainMenu.fl.projects -tearoff 0]

	createProjectMenu $openProject

	$mainMenu add cascade -menu $mainMenu.fl -label File -underline 0

	$mainMenu.fl add cascade -label "Open Project" -menu $openProject
	$mainMenu.fl add separator
	$mainMenu.fl add command -underline 1 -label Exit -command { exit }

        bind . <Control-q> {exit}

	menu $mainMenu.ts -tearoff 0
	$mainMenu add cascade -menu $mainMenu.ts -label Tools -underline 0

	set dbCascade [menu $mainMenu.ts.cascade -tearoff 0]
	$dbCascade add command -label "Database deploy" -command {::docker-helper::dockerLoadDump}
	$dbCascade add separator
	$dbCascade add command -label "Set base url" -command {::docker-helper::dockerRunPasswordParameter "./bin/set_base_url.sh" "Enter Base Url:" 0}
	$dbCascade add command -label "Show base url" -command {::docker-helper::runCommand "./bin/show_base_url.sh"}
	$dbCascade add separator
	$dbCascade add command -label "Set XDebug IP" -command {::docker-helper::dockerSetXDebugIP}
	$dbCascade add separator
	$dbCascade add command -label "Set Admin Password" -command {::docker-helper::runCommand "./bin/create_admin.sh"}
	
	
	$mainMenu.ts add command -label "Docker Run" -command { ::docker-helper::confirm "./bin/run.sh" "Are you sure you want to re-install container?"}
	$mainMenu.ts add command -label "Docker Rebuild" -command {::docker-helper::runTerminal "./bin/rebuild.sh"}
	$mainMenu.ts add command -label "Stop all containers" -command {::docker-helper::runCommand "docker-compose stop"}
	$mainMenu.ts add separator
	$mainMenu.ts add command -label "Clear env" -command {::docker-helper::confirm "./bin/clear_env.sh" "Are you sure?"}
	$mainMenu.ts add command -label "Clear all" -command {::docker-helper::confirm "./bin/clear.sh" "Are you sure you want to clear container and database?"}
	$mainMenu.ts add separator
	$mainMenu.ts add command -label "Deploy Demo" -command {::docker-helper::runTerminal "./bin/deploy_demo.sh"}
	$mainMenu.ts add command -label "Install Magento" -command {::docker-helper::runCommand "./bin/install_magento.sh"}
	$mainMenu.ts add separator
	$mainMenu.ts add cascade -label "DB util..." -menu $dbCascade

	menu $mainMenu.run -tearoff 0
	$mainMenu add cascade -menu $mainMenu.run -label Docker -underline 0

	set runCascade [menu $mainMenu.run.cascade -tearoff 0]
	$runCascade add command -label "Run command in php-fpm" -command {::docker-helper::dockerRunParameter "./bin/execute.sh" "Enter command:" 1}
	$runCascade add command -label "Run php script" -command {::docker-helper::dockerRunParameter "./bin/php.sh" "Enter PHP command:" 0}
	$runCascade add command -label "Run magento command" -command {::docker-helper::dockerRunParameter "./bin/magento" "Enter Magento command:" 0}
	$runCascade add command -label "Run Redis Cli" -command {::docker-helper::runTerminal "./bin/redis-cli"}
	$runCascade add separator
	$runCascade add command -label "Run grunt" -command {::docker-helper::dockerRunParameter "./bin/grunt" "Enter command:" 1}
	$runCascade add command -label "Run N98-magerun2" -command {::docker-helper::dockerRunParameter "./bin/n98-magerun2" "Enter command:" 1}
	$runCascade add command -label "Rin N98-magerun"  -command {::docker-helper::dockerRunParameter "./bin/n98-magerun" "Enter command:" 1}
	
	set runNodeJs  [menu $mainMenu.run.nodejs -tearoff 0]
	set deityPWA   [menu $mainMenu.run.nodejs.deity -tearoff 0]
	set magentoPWA [menu $mainMenu.run.nodejs.magento -tearoff 0]
	set scandiPWA  [menu $mainMenu.run.nodejs.scandi -tearoff 0]

	$deityPWA add command -label "Install Deity PWA" -command {::docker-helper::runTerminal "./bin/install-falcon.sh"}
	$deityPWA add command -label "Install Deity Magento2 Module" -command {::docker-helper::runTerminal "./bin/unpack_deity.sh"}
	$deityPWA add command -label "Run Deity Falcon Client-Server" -command {::docker-helper::runTerminal "./bin/start_falcon.sh"}
	
	$magentoPWA add command -label "Install Magento PWA Studio" -command {::docker-helper::runTerminal "./bin/install-pwa-studio.sh"}
	$magentoPWA add command -label "Build" -command {::docker-helper::runTerminal "./bin/studio-build.sh"}
	$magentoPWA add command -label "Run Venia" -command {::docker-helper::runTerminal "./bin/studio-run-venia.sh"}
	$magentoPWA add command -label "Run Full Studio" -command {::docker-helper::runTerminal "./bin/studio-run-full.sh"}

	$scandiPWA add command -label "Install Scandi PWA" -command {::docker-helper::runTerminal "./bin/install-scandipwa.sh"}
	$scandiPWA add separator
	$scandiPWA add command -label "Run Scandi PWA" -command {::docker-helper::runTerminal "./bin/run-scandipwa.sh"}

	$runNodeJs add command -label "Run NodeJs Shell" -command {::docker-helper::dockerConnect nodejs}
	$runNodeJs add separator
	$runNodeJs add cascade -label "Deity PWA" -menu $deityPWA
	$runNodeJs add separator
	$runNodeJs add cascade -label "Magento PWA Studio" -menu $magentoPWA
	$runNodeJs add separator
	$runNodeJs add cascade -label "Scandi PWA" -menu $scandiPWA
	

	$mainMenu.run add command -label "Show running containers" -command {::docker-helper::runCommand "docker-compose ps"}
	$mainMenu.run add separator
	$mainMenu.run add command -label "Connect php-shell" -command {::docker-helper::dockerConnect phpfpm}
	$mainMenu.run add command -label "Connect mysql" -command {::docker-helper::dockerConnect db}
	$mainMenu.run add command -label "Connect nginx" -command {::docker-helper::dockerConnect web}
	$mainMenu.run add command -label "Connect redis" -command {::docker-helper::dockerConnect redis}
	$mainMenu.run add separator
	$mainMenu.run add cascade -label "NodeJs..." -menu $runNodeJs
	$mainMenu.run add separator
	$mainMenu.run add cascade -label "Run..." -menu $runCascade


	menu $mainMenu.help -tearoff 0
	$mainMenu add cascade -menu $mainMenu.help -label Help -underline 0
	$mainMenu.help add command -label "Show Commands" -command {::docker-helper::showHelp}
	
        bind . <F1> {::docker-helper::showHelp}
	#$mainMenu.help add command -label "Show Commands" -command {::docker-helper::runCommand "cat ../docker-helper/help.docker"}
	
	wm title . "Docker Helper" 
	wm geometry . 800x600+300+300

	$bottomLabel configure -text "Current derictory: [pwd]"
    }

    proc showHelp {} {
        variable mainList
    
        set path [string trimright [pwd] "compose"]docker-helper/help.docker

        if {[catch {open $path} helperFile]} {
            output error "Helper file are missing!"
        } else {
            $mainList configure -state normal
            $mainList delete 1.0 end
            while {[gets $helperFile line] >= 0} {
                output normal $line
            }
            close $helperFile
            $mainList see 1.0
        }
    }
    
    proc confirm {cmd text} {
        if {[tk_messageBox -type "yesno" -message $text -icon warning -title "Warning..."] == "yes"} {
            output normal "Running $cmd"
            runTerminal $cmd
            output normal "Done"
        }
    }

    #
    # connnect to container
    #
    proc dockerConnect {type} {
	runTerminal "docker-compose exec $type /bin/bash"
    }

    proc dockerRunParameter {runCmd labelText inTerminal} {
	variable inputVariable

	single_value_dialog $labelText

	if {$inTerminal == 1} {
	    runTerminal "$runCmd $inputVariable"
	} else {
	    runCommand "$runCmd $inputVariable"
	}
    }

    proc dockerRunPasswordParameter {runCmd labelText inTerminal} {
	variable inputVariable 
	variable sudoPassword

	password_value_dialog $labelText

	if {$inTerminal == 1} {
	    runTerminal "$runCmd $inputVariable $sudoPassword"
	} else {
	    runCommand "$runCmd $inputVariable $sudoPassword"
	}
    }

    #
    # deploy magento demo
    #
    proc dockerDeployDemo {} {
	set dir [tk_chooseDirectory -initialdir [pwd]/src-packed -title "Choose version..."]

	if {$dir eq ""} {
	    puts none
	} else {
	    set dir [string range $dir [string last "/" $dir]+1 end]
	    puts $dir
	    runTerminal "./bin/deploy_demo.sh $dir"
	}
    }

    #
    # set IP for remote debugging
    #
    proc dockerSetXDebugIP {} {
	variable currentTerminal 
	variable inputVariable

	set val [lindex [list [split [split [exec "../docker-helper/get_ip.sh"] "\n"] " "]] 0]
	
	listbox_dialog "Select IP" $val
        
        if {$inputVariable != ""} {
	    runCommand "./bin/set_xdebug_ip.sh $inputVariable"
	}
    }

    #
    # database deploy
    #
    proc dockerLoadDump {} {
	set currDir [pwd]
	
	set types {
	    {"DB dump" {.sql .gz }}
	}

	set file [tk_getOpenFile -initialdir $currDir/sql/src -filetypes $types -parent . -title "Select db dump"] 

	cd $currDir

	if {$file eq ""} {
	    puts none
	} else {
	    runCommand "./bin/deploy_database.sh [file tail $file]"
	}
    }

    #
    # get "compose" directory for project
    #
    proc loadProject {} {
	variable bottomLabel
	
	set types {
	    {"Docker YML" {.yml }}
	}

	set file [tk_getOpenFile -filetypes $types -initialfile "docker-compose.shared.yml"  -parent . -title "Select project file"]
	set workingDir [file dirname $file]
	cd $workingDir
	$bottomLabel configure -text "Current derictory: [pwd]"
    }


    #
    # Main window run command/show result utilites
    #
    proc runCommand {cmd} {
	variable mainList 
	variable bottomLabel
	
	# set wait cursor
	$mainList config -cursor watch

	output normal "Running..." 
	set f [open "| $cmd"]
	fileevent $f readable [list ::docker-helper::handleFileEvent $f]
	fconfigure $f -blocking 0
    }

    proc closePipe {f} {
	variable mainList
	
	# blocking on
	fconfigure $f -blocking true
	if {[catch {close $f} err]} {
	    output error $err
	}

	# restore cursor
	output normal "Done." 
	$mainList config -cursor left_ptr
    }

    proc handleFileEvent {f} {
	set status [catch { gets $f line } result]
	if { $status != 0 } {
	    output error $result
	    # closePipe $f
	} elseif { $result >= 0 } {
	    output normal $line
	} elseif { [eof $f] } {
	    closePipe $f
	} elseif { [fblocked $f] } {
	    # Blocked 
	}
    }

    proc output {type text} {
	variable mainList
	$mainList configure -state normal
	$mainList insert end $text $type "\n"
	$mainList see end
	$mainList configure -state disabled
    }

    #
    # show input dialog
    #
    proc single_value_dialog {title} {

	set ::docker-helper::inputVariable ""
	set modalW [toplevel .[clock seconds]]

	label  $modalW.l -text $title -borderwidth 1 -padx 5 -pady 5
	entry  $modalW.e -textvariable ::docker-helper::inputVariable -bg white -borderwidth 1 

	bind $modalW.e <Return> {set done 1}

	button $modalW.ok -text OK -command {set done 1} -padx 5 -pady 5

	grid $modalW.l -sticky news
	grid $modalW.e -sticky news
	grid $modalW.ok  -sticky e

	wm withdraw $modalW
	update
	set x [expr {([winfo screenwidth .]-[winfo width $modalW])/2}]
	set y [expr {([winfo screenheight .]-[winfo height $modalW])/2}]
	wm geometry $modalW +$x+$y
	wm title $modalW "Set Domain"
	wm transient $modalW
	wm deiconify $modalW

	vwait done

	destroy $modalW
    }

    #
    # show input dialog
    #
    proc password_value_dialog {title} {
	global tcl_platform

	set modalW [toplevel .[clock seconds]]

	set ::docker-helper::inputVariable ""
	set ::docker-helper::sudoPassword ""

	label  $modalW.l -text $title -borderwidth 1 -padx 5 -pady 5
	entry  $modalW.e -textvariable ::docker-helper::inputVariable -bg white -borderwidth 1 

	label  $modalW.passLabel -text "sudo password for user $tcl_platform(user):" -borderwidth 1 -padx 5 -pady 5
	entry  $modalW.passValue -textvariable ::docker-helper::sudoPassword -bg white -borderwidth 1 -show "*"
	
	bind $modalW.e <Return> {set done 1}

	button $modalW.ok -text OK -command {set done 1} -padx 5 -pady 5

	grid $modalW.l -sticky news
	grid $modalW.e -sticky news
	grid $modalW.passLabel -sticky news
	grid $modalW.passValue -sticky news
	grid $modalW.ok  -sticky e

	wm withdraw $modalW
	update
	set x [expr {([winfo screenwidth .]-[winfo width $modalW])/2}]
	set y [expr {([winfo screenheight .]-[winfo height $modalW])/2}]
	wm geometry $modalW +$x+$y
	wm title $modalW "Set Domain"
	wm transient $modalW
	wm deiconify $modalW

	vwait done

	destroy $modalW
    }

    #
    # show listbox dialog
    #
    proc listbox_dialog {title values} {

	set modalW [toplevel .[clock seconds]]

	label  $modalW.l -text $title -borderwidth 1 -padx 5 -pady 5
	listbox  $modalW.ipListBox

	foreach {ip} [split $values " "] {
	    $modalW.ipListBox insert end $ip
	}

	button $modalW.ok -text OK -command {set done 1} -padx 5 -pady 5

	grid $modalW.l -sticky news
	grid $modalW.ipListBox -sticky news
	grid $modalW.ok  -sticky e

	wm withdraw $modalW
	update
	set x [expr {([winfo screenwidth .]-[winfo width $modalW])/2}]
	set y [expr {([winfo screenheight .]-[winfo height $modalW])/2}]
	wm geometry $modalW +$x+$y
	wm title $modalW "Select value"
	wm transient $modalW
	wm deiconify $modalW

	vwait done
	set ::docker-helper::inputVariable [$modalW.ipListBox get [$modalW.ipListBox curselection]]

	destroy $modalW
    }

    #
    # start terminal with command
    #
    proc runTerminal {cmdline} {
	variable currentTerminal
	variable terminalAdditionCommands

	exec $currentTerminal -e "$cmdline $terminalAdditionCommands"
    }
    
    proc createProjectMenu {pMenu} {
        variable startDirectory
        
        set startDirectory [pwd]
        
        if {![catch {glob -type f "$startDirectory/../GetProjectDirs.sh"} globError]} {
            set dirs [glob -type d ../../../*]
        } else {
            set dirs [glob -type d ../../*]
        }
        
        set currentDir [pwd]
        
        foreach {path} [split $dirs " "] {
            if (![catch {glob -type d $path/compose } globError]) {
                cd $path/compose
	        set workingDir [pwd]
                if (![catch {glob -type f "docker-compose.shared.yml"} globError]) {
                    set command "::docker-helper::changeProjectDir $workingDir"
                    $pMenu add command -label $workingDir -command $command
                }
            }
        }
        
        cd $currentDir
    }

    proc changeProjectDir {path} {
	variable bottomLabel

	cd $path
	$bottomLabel configure -text "Current derictory: [pwd]"
   }
}

#
# run helper
#
::docker-helper::main

