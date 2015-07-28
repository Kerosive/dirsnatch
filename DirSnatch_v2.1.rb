require 'rubygems'
require 'wx'
require 'find'
include Wx

Button_Get_Snatch = 1
Button_Exit = 2
Button_Get_Browse = 3
Button_Get_Save = 4
Button_Put_Snatch = 5
Button_Put_Browse = 6
Button_Put_Save = 7

class DirSnatchFrame < Frame 
  def initialize
    super(nil, -1, "DirSnatch_v2.0", Point.new(100, 100), Size.new(550, 240))
    
    tab = Notebook.new(self, -1, Point.new(1,1), Size.new(88,24))        
    
    get_panel = Panel.new(tab)
    
    put_panel = Panel.new(tab)
    
    tab.add_page(get_panel, "DirGet", TRUE) 
    tab.add_page(put_panel, "DirPut", FALSE)
      
    
    
 #Beginning of DirGet tab visuals   
    
    getDirText = StaticText.new(get_panel, -1, "Enter Web Directory", Point.new(220, 0))  
    @getText = TextCtrl.new(get_panel, -1, "", Point.new(5, 20), Size.new(435, 20))
      
    getDirectoryButton = Button.new(get_panel, Button_Get_Browse, "Browse", Point.new(445, 18))
    
    getlist = %w(http:// https://)  
    @getComboBox = ComboBox.new(get_panel, -1, "Choose One", Point.new(5,60), Size.new(90, 20), getlist, CB_READONLY)
    
    getUrlText = StaticText.new(get_panel, -1, "Enter the URL of the website", Point.new(202, 40))
    @getText1 = TextCtrl.new(get_panel, -1, "", Point.new(95, 60), Size.new(425, 20))
    
    getLocText = StaticText.new(get_panel, -1, "Location to save", Point.new(228, 80))
    @getText2 = TextCtrl.new(get_panel, -1, "", Point.new(5, 100), Size.new(435, 20))
      
    getSaveAsButton = Button.new(get_panel, Button_Get_Save, "Save As", Point.new(445, 98))
    
    getSnatchButton = Button.new(get_panel, Button_Get_Snatch, "Snatch!", Point.new(229, 125))
    
    getExitButton = Button.new(get_panel, Button_Exit, "Exit", Point.new(229, 150))
      
 # End of DirGet tab visuals  
 
 #Beginning of DirPut tab visuals   
       
    putDirText = StaticText.new(put_panel, -1, "Enter Web Directory", Point.new(220, 0))  
    @putText = TextCtrl.new(put_panel, -1, "", Point.new(5, 20), Size.new(435, 20))
         
    putDirectoryButton = Button.new(put_panel, Button_Put_Browse, "Browse", Point.new(445, 18))
       
    putlist = %w(http:// https://)  
    @putComboBox = ComboBox.new(put_panel, -1, "Choose One", Point.new(5,60), Size.new(90, 20), putlist, CB_READONLY)
       
    putUrlText = StaticText.new(put_panel, -1, "Enter the URL of the website", Point.new(202, 40))
    @putText1 = TextCtrl.new(put_panel, -1, "", Point.new(95, 60), Size.new(425, 20))
       
    putLocText = StaticText.new(put_panel, -1, "Location to save", Point.new(228, 80))
    @putText2 = TextCtrl.new(put_panel, -1, "", Point.new(5, 100), Size.new(435, 20))
         
    putSaveAsButton = Button.new(put_panel, Button_Put_Save, "Save As", Point.new(445, 98))
       
    putSnatchButton = Button.new(put_panel, Button_Put_Snatch, "Snatch!", Point.new(229, 125))
    putExitButton = Button.new(put_panel, Button_Exit, "Exit", Point.new(229, 150))
         
# End of DirPut tab visuals        
    
    show(true)
    evt_button(Button_Exit) {onExit}
    evt_button(Button_Get_Snatch) {getGo}
    evt_button(Button_Get_Browse) {getOnDir}
    evt_button(Button_Get_Save) {getOnSave}
    evt_button(Button_Put_Snatch) {putGo}
    evt_button(Button_Put_Browse) {putOnDir}
    evt_button(Button_Put_Save) {putOnSave}

end

def getOnDir
  frame = Frame.new
  dlg = DirDialog.new(frame, "Choose a directory:")
  dlg.show_modal()
  @getText.write_text(dlg.get_path())
end

def putOnDir
  frame = Frame.new
  dlg = DirDialog.new(frame, "Choose a directory:")
  dlg.show_modal()
  @putText.write_text(dlg.get_path())
end

$wildcard = "Text File (*.txt)|*.txt* |All Files (*.*)|*.*|"

def getOnSave
  frame = Frame.new
  dlg = FileDialog.new(frame, "Save File As", Dir.getwd(), "", $wildcard, SAVE)
  dlg.set_filter_index(2)
  dlg.show_modal()
  path = dlg.get_path()
  @getText2.write_text(dlg.get_path)
end

def putOnSave
  frame = Frame.new
  dlg = FileDialog.new(frame, "Save File As", Dir.getwd(), "", $wildcard, SAVE)
  dlg.set_filter_index(2)
  dlg.show_modal()
  path = dlg.get_path()
  @putText2.write_text(dlg.get_path)
end

def getChoice
  getChoice = @getComboBox.get_value
end

def putChoice
  putChoice = @putComboBox.get_value
end
  
def getDirectory
  getDirectory = @getText.get_value
end

def putDirectory
   putDirectory = @putText.get_value
end

def getUrl
  getUrl = @getText1.get_value
end

def putUrl
  putUrl = @putText1.get_value
end

def get_file_name 
  get_file_name = @getText2.get_value
end

def put_file_name 
  put_file_name = @putText2.get_value
end

 def onExit
   close(true)
 end 
 
 def getSnatchIt
   count = 0
   Find.find(getDirectory) do |path| count +=1 
   @max = count
   end
   get_out_file = File.open(get_file_name, "w")  
   frame = Frame.new
   dlg = ProgressDialog.new("Working", "Progression", @max, frame, PD_CAN_ABORT|PD_APP_MODAL)
   Find.find(getDirectory) do |path| count +=1 
   get_out_file.write(getChoice+getUrl+path+"\n")
   dlg.update(count)
   end
   dlg.destroy()
   
   
   get_out_file.close
   getAction = File.read(get_file_name)
   getResult = getAction.gsub(getDirectory, '').gsub(/\\/, '/') do each 
   end
   File.open(get_file_name, "w") { |f| f.write getResult }  
   end

def putSnatchIt
 count = 0
 Find.find(getDirectory) do |path| count +=1 
 @max = count
 end
 put_out_file = File.open(put_file_name, "w")  
 frame = Frame.new
 dlg = ProgressDialog.new("Working", "Progression", @max, frame, PD_CAN_ABORT|PD_APP_MODAL)
 Find.find(putDirectory) do |path| count +=1
     put_result = FileTest.directory?(path)
     if put_result == true
     put_out_file.write(putChoice+putUrl+path+'/'+"\n")
     dlg.update(count)
     else
   end
end
dlg.destroy()
put_out_file.close
putAction = File.read(put_file_name)
putResult = putAction.gsub(putDirectory, '').gsub(/\\/, '/') do each 
end
File.open(put_file_name, "w") {|f| f.write putResult}
end


def getGo
  Thread.new do
   begin
    getSnatchIt
     rescue Errno::EINVAL
    rescue  Errno::ENOENT
    end
  end
end


def putGo
  Thread.new do 
   begin
    putSnatchIt
    rescue Errno::EINVAL
    rescue Errno::ENOENT
    end
  end
end

end

class DirSnatchApp < App
  def on_init
    DirSnatchFrame.new
    t = Timer.new(self, 10)
    evt_timer(10) { Thread.pass }
    t.start(1)
  end
end


  DirSnatchApp.new.main_loop
