##
# title: breadinterface.py
# by: Brian Kim
# description: the python script that contain all the necessary components for breadinterface
#

import pygtk
pygtk.require('2.0')
import gtk

##
# an interface that defines the life cycle of a breadinterface component
#
class lifecycle():
  def __init__( self ):
    pass

  def start( self ):
    pass
    
  def resume( self ):
    pass

  def update( self ):
    pass

  def clear( self ):
    pass

  def pause( self ):
    pass

  def stop( self ):
    pass

  def cleanup( self ):
    pass

##
# an interface that defines the button labels and click actions
#
class buttons():

  @staticmethod
  def gtk_button( text, scale=1 ):
    """ returns a properly styled gtk button for breadinterface """
    # create the button
    y = gtk.Button( text )

    # set the size
    size = 44 * scale
    y.set_size_request( size, size )

    # remove the relief
    y.props.relief = gtk.RELIEF_NONE

    # set the color style on the label
    label = y.get_child()
    style = label.get_style().copy()
    style.bg[gtk.STATE_NORMAL] = gtk.gdk.color_parse( "black" ) 
    style.fg[gtk.STATE_NORMAL] = gtk.gdk.color_parse( "white" ) 
    label.set_style(style)
     
    # set the color style on the button
    style = y.get_style().copy()
    style.bg[gtk.STATE_NORMAL] = gtk.gdk.color_parse( "black" ) 
    style.fg[gtk.STATE_NORMAL] = gtk.gdk.color_parse( "white" ) 
    y.set_style(style)

    # return the button
    return y
    
  # text labels
  def tl_label( self ):
    return ''

  def tm_label( self ):
    return ''

  def tr_label( self ):
    return ''

  def bl_label( self ):
    return ''

  def bm_label( self ):
    return ''

  def br_label( self ):
    return ''

  # clicked actions
  def tl_clicked( self, widget ):
    print 'tl clicked'

  def tm_clicked( self, widget ):
    print 'tm clicked'

  def tr_clicked( self, widget ):
    print 'tr clicked'

  def bl_clicked( self, widget ):
    print 'bl clicked'

  def bm_clicked( self, widget ):
    print 'bm clicked'

  def br_clicked( self, widget ):
    print 'br clicked'

#==========================================
# begin definition of core classes
#==========================================

##
# the Settings class will be defined as a 
# singleton oject
# code from http://code.activestate.com/recipes/52558/
class Settings():
  # storage for the instance reference
  __instance = None

  def __init__(self, app_name="app"):
    """ Create singleton instance """
    # Check whether we already have an instance
    if Settings.__instance is None:
      # we need an app_name

      # create and remember instance
      Settings.__instance = Settings.SettingsClass(app_name)
    self.__dict__['_Settings__instance'] = Settings.__instance

  def __getattr__(self, attr):
    """ Delegate access to implementation """
    return getattr(self.__instance, attr)

  def __setattr__(self, attr, value):
    """ Delegate access to implementation """
    return setattr(self.__instance, attr, value)

  ##
  # setttings class
  #  ivars: dict
  #
  class SettingsClass():
    def __init__( self, app_name ):
      # parse the file and set the dict to the ivar _dict
      self._dict = Settings.SettingsClass.get_settings( app_name )

    ##
    # creates the settings file path
    @staticmethod
    def settings_file_path( app_name ):
      # get the home path
      from os.path import expanduser
      home_dir = expanduser("~")
      
      # create the settings file name
      fname = "." + app_name + "_settings"

      # return the home_dir + file name
      return home_dir + "/" + fname

    ##
    # @param app_name this variable will determine the name of the settings file
    #
    @staticmethod
    def get_settings( app_name ):
      """ returns a dictionary of the key/value pairs in the file """
      # get the settings path
      settings_path = Settings.SettingsClass.settings_file_path(app_name.replace(' ', '_'))
  
      try:
        # open the settings file 
        settings_fp = open( settings_path, "r" )
      except:
        settings_fp = open( settings_path, "w+" )
        settings_fp.write( 'app_name='+app_name+'\n' )
        settings_fp.close()
        settings_fp = open( settings_path, "r" )

  
      # y = return variable
      y = {}
  
      # get the key value  
      for line in settings_fp:
        # convert it to an array
        pair = line.split('=')
        # get the key and the value
        key = pair[0]
        value = pair[1]
        # store the key value pair in the return variable
        y[key] = value
  
      # close the file pointer
      settings_fp.close()
  
      return y
  
    def save( self ):
      """ method to save the settings dictionary """
      # get the home path
      from os.path import expanduser
      home_dir = expanduser("~")
      
      # create the settings file name
      fname = "." + app_name + "_settings"
      settings_path = home_dir + "/" + fname
  
      # open the settings file 
      settings_fp = open( settings_path, "w+" )

      # print the key/value pair into the settings file
      for key in self._dict:
        print_line = key + '=' + self._dict[key] +'\n'
        settings_fp.write(print_line)

      # close the settings file
      settings_fp.close()
  
    def set( self, key, value, override=False ):
      """ sets a setting """
      try:
        x = self._dict[key]
      except KeyError:
        self._dict[key] = str(value)
  
      if not x == None and override:
        self._dict[key] = value
  
    def get( self, key, default="1312340" ):
      """ gets a setting """
      try: 
        return self._dict[key]
      except:
        return default

##
# navigator class
#
class Navigator( lifecycle ):

  #
  # lifecycle methods
  # 
  def __init__( self, root ):
    self.window = gtk.Window()
    self.window.set_size_request( 320, 480)
    self.window.connect("delete-event", gtk.main_quit)

    root.nav = self
    self.ctrlrs = [ root ]
            
  def start_top( self ):
    self.window.add( self.current().frame )
    self.current().start()
          
  def start( self ):
    self.start_top()
    self.window.show()
    gtk.main()

  def resume( self ):
    self.current().resume()

  def pause( self ):
    self.current().pause()

  def stop_top( self ):
    self.window.remove( self.current().frame )
    self.current().stop()

  def stop( self ):
    self.stop_top()
    self.window.hide()
    gtk.main_quit()

  #
  # navigation stack methods
  #

  """ the current controller on screen """
  def current( self ):
    return self.ctrlrs[self.size() - 1]

  def push( self, controller ):
    # stop the top controller
    self.stop_top()

    # create reference to nav
    controller.nav = self

    # add the controller to the stack
    self.ctrlrs.append( controller )

    # start the new top controller
    self.start_top()

  def pop( self ): 
    # stop the top controller
    self.stop_top()

    # remove the top controller from the stack
    y = self.ctrlrs.pop()

    # destory that controller
    y.stop()

    # close the app if that was the last controller
    if self.size() == 0:
      gtk.main_quit()
      return

    # start the next controller in the stack
    self.start_top()

  def root( self ):
    # simply the first controller
    return self.ctrlrs[0]

  def size( self ):
    # the size of the stack
    return len( self.ctrlrs )

##
# controller class
#
class Controller( buttons, lifecycle ):

  #
  # breadinterface lifecycle methods
  #

  def __init__( self, title='breadinterface', view=gtk.TreeView() ):
    self.title = title
  
    # controller
    self.frame = gtk.VBox()
  
    # frame
    self.top = gtk.HBox()
    self.view = view
    self.bottom = gtk.HBox()

    # bar
    self.tl = gtk.Button(self.tl_label())
    self.tm = gtk.Button(self.tm_label())
    self.tr = gtk.Button(self.tr_label())
    self.bl = gtk.Button(self.bl_label())
    self.bm = gtk.Button(self.bm_label())
    self.br = gtk.Button(self.br_label())
  
    # fixing the size of the buttons
    self.tl.set_size_request( 44, 44 )
    self.tr.set_size_request( 44, 44 )
    self.bl.set_size_request( 44, 44 )
    self.br.set_size_request( 44, 44 )

    # remove the borders
    self.tl.props.relief = gtk.RELIEF_NONE
    self.tm.props.relief = gtk.RELIEF_NONE
    self.tr.props.relief = gtk.RELIEF_NONE
    self.bl.props.relief = gtk.RELIEF_NONE
    self.bm.props.relief = gtk.RELIEF_NONE
    self.br.props.relief = gtk.RELIEF_NONE

    # hook up the button actions
    self.tl.connect( "clicked", self.tl_clicked )
    self.tm.connect( "clicked", self.tm_clicked )
    self.tr.connect( "clicked", self.tr_clicked )
    self.bl.connect( "clicked", self.bl_clicked )
    self.bm.connect( "clicked", self.bm_clicked )
    self.br.connect( "clicked", self.br_clicked )

    # creating the button info dictionary
    self.button_info_dict = {}
    self.button_info_dict['tl'] = 'None'
    self.button_info_dict['tr'] = 'None'
    self.button_info_dict['bl'] = 'None'
    self.button_info_dict['bm'] = 'None'
    self.button_info_dict['br'] = 'None'

    # build the view
    self.top.pack_start( self.tl,False)
    self.top.pack_start( self.tm,True)
    self.top.pack_start( self.tr,False)

    self.bottom.pack_start( self.bl,False)
    self.bottom.pack_start( self.bm,True)
    self.bottom.pack_start( self.br,False)

    self.frame.pack_start( self.top,False)
    self.frame.pack_start( self.view,True)
    self.frame.pack_start( self.bottom,False)

  #
  # breadinterface button layout
  # - defaulting the top-middle label to be the title
  # - making the default button click to display button info
  #
  def tm_label( self ):
    return self.title

  def tm_clicked( self, v ):
    msg = gtk.MessageDialog( parent=None,
                             flags=0,
                             type=gtk.MESSAGE_INFO,
                             buttons=gtk.BUTTONS_NONE,
                             message_format=None )
    info = 'Button Layout\n\ntop-left: '+self.tl_label()+' : '
    info += self.button_info_dict['tl']
    info += '\ntop-right: '+self.tr_label()+' : '
    info += self.button_info_dict['tr']
    info += '\nbottom-left: '+self.bl_label()+' : '
    info += self.button_info_dict['bl']
    info += '\nbottom-middle: '+self.bm_label()+' : '
    info += self.button_info_dict['bm']
    info += '\nbottom-right: '+self.br_label()+' : '
    info += self.button_info_dict['br']
    info += '\n\nPress ESC twice to close this popup'
    msg.set_markup( info )
    msg.run()

  def start( self ):
    self.resume()

  def resume( self ):
    self.frame.show_all()
    self.update()

  def update( self ):
    self.tl.set_label( self.tl_label() )
    self.tm.set_label( self.tm_label() )
    self.tr.set_label( self.tr_label() )
    self.bl.set_label( self.bl_label() )
    self.bm.set_label( self.bm_label() )
    self.br.set_label( self.br_label() )
    self.view.update()

  def clear( self ):
    pass

  def pause( self ):
    self.frame.hide_all()

  def stop( self ):
    self.pause()
  
  

class SuitsController( Controller ):
  spade = unichr(9828)
  heart = unichr(9825)
  club = unichr(9826)
  diamond = unichr(9831)

  def __init__( self ):
    self.label = gtk.Label("NULL")
    import pango
    self.label.modify_font( pango.FontDescription("sans 72" ))
    Controller.__init__( self, view=self.label )

  def tl_label( self ):
    return self.spade

  def tl_clicked( self, widget ):
    self.label.set_text( self.spade )

  def tm_label( self ):
    return 'Suits'

  def tr_label( self ):
    return self.heart

  def tr_clicked( self, widget ):
    self.label.set_text( self.heart )

  def bl_label( self ):
    return  self.club

  def bl_clicked( self, widget ):
    self.label.set_text( self.club )

  def bm_label( self ):
    return 'click a suit'

  def bm_clicked( self, widget ):
    self.nav.pop()

  def br_label( self ):
    return self.diamond

  def br_clicked( self, widget ):
    self.label.set_text( self.diamond )

class PrototypeController( Controller ):

  #
  # breadinterface buttons definition
  #
  def tl_label( self ):
    #return self._tl_label
    return '?'	

  def tm_label( self ):
    #return self._tm_label
    return 'Sample Controller'
	
  def tr_label( self ):
    #return self._tr_label
    return unichr(0x2699)

  def bl_label( self ):
    #return self._bl_label
    return '+'

  def bm_label( self ):
    #return self._bm_label
    return 'by Fee'

  def br_label( self ):
    #return self._br_label
    return '-'

  def tl_clicked( self, widget ):
    self._tl_label = self.view.entry.get_text()
    self.update()

  def tm_clicked( self, widget ):
    Controller.tm_clicked( self, widget )
    self._tm_label = self.view.entry.get_text()
    self.update()

  def tr_clicked( self, widget ):
    self._tr_label = self.view.entry.get_text()
    self.update()

  def bl_clicked( self, widget ):
    self._bl_label = self.view.entry.get_text()
    self.update()

  def bm_clicked( self, widget ):
    self._bm_label = self.view.entry.get_text()
    self.update()

  def br_clicked( self, widget ):
    self._br_label = self.view.entry.get_text()
    self.update()
  
  def update( self ):
    Controller.update(self)
    self.view.clear()

  ##
  # custom constructor
  #
  def __init__( self ):
    self._tl_label = "tl"
    self._tm_label = "tm"
    self._tr_label = "tr"
    self._bl_label = "bl"
    self._bm_label = "bm"
    self._br_label = "br"
    Controller.__init__( self, view=PrototypeController.PrototypeView() )
    self.button_info_dict['tl'] = 'change button label to text field value'
    self.button_info_dict['tr'] = 'change button label to text field value'
    self.button_info_dict['bl'] = 'change button label to text field value'
    self.button_info_dict['bm'] = 'change button label to text field value'
    self.button_info_dict['br'] = 'change button label to text field value'

  ##
  # custom view class definition
  #
  class PrototypeView( gtk.Alignment, lifecycle ):
    def __init__( self ):
      gtk.Alignment.__init__( self, 0.4, 0.4, 0.6, 0.6 )
      self.entry = gtk.Entry()
      self.add( self.entry )

    def clear( self ):
      self.entry.set_text("")

##
# app class 
#
class App( lifecycle ):
  def __init__( self, root=PrototypeController(), appName='breadinterface' ):
    # init the app components
    self.settings = Settings(appName)
    self.navigator = Navigator( root )
    self.navigator.window.set_title( appName )

  def cleanup( self ):
    self.settings.cleanup()
    self.navigator.cleanup()

  def start( self ):
    self.navigator.start()

  def resume( self ):
    self.navigator.resume()

  def pause( self ):
    self.navigator.pause()

  def stop( self ):
    self.navigator.stop()


def main():
  app = App(appName='breadinterface prototype')
  app.start()

if __name__ == "__main__":
  main()
