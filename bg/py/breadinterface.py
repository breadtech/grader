##
# title: breadinterface.py
# by: Brian Kim
# description: the python script that contain all the necessary components for breadinterface
#

##
# an interface that defines the life cycle of a breadinterface component
#
class lifecycle():
  def __init__( self ):
    pass

  def start( self ):
    pass
    
  def stop( self ):
    pass

  def update( self ):
    pass

  def cleanup( self ):
    pass

##
# an interface that defines the button labels and click actions
#
class buttons():

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

##
# begin definition of core classes
# 

import pygtk
pygtk.require('2.0')
import gtk

##
# setttings class
#
class Settings():
  def __init__( self ):
    self.dict = { 'app_name' : 'breadinterface' }

  def get_app_name( self ):
    return self.dict['app_name']
    
  def set_app_name( self, app_name ):
    self.dict['app_name'] = app_name

  def set( self, key, value, override=False ):
    try:
      x = self.dict[key]
    except KeyError:
      self.dict[key] = value

    if not x == None and override:
      self.dict[key] = value

  def get( self, key ):
    return self.dict[key]

##
# navigator class
#
class Navigator( lifecycle ):
  def __init__( self, root ):
    self.window = gtk.Window()
    self.window.set_size_request( 320, 480)
    self.window.connect("delete-event", gtk.main_quit)

    root.nav = self
    self.ctrlrs = [ root ]
    
  """ the current controller on screen """
  def current( self ):
    return self.ctrlrs[self.size() - 1]

  def push( self, controller ):
    # pause the top controller
    self.current().stop()

    # create reference to nav
    controller.nav = self

    # add the controller to the stack
    self.ctrlrs.append( controller )

    # start the new top controller
    self.start()

  def pop( self ):
    # remove the top controller from the stack
    y = self.ctrlrs.pop()

    # destory that controller
    y.cleanup()

    # start the next controller in the stack
    self.start()

  def root( self ):
    # simply the first controller
    return self.ctrlrs[0]

  def size( self ):
    # the size of the stack
    return len( self.ctrlrs )
                      
  def start( self ):
    # starts the navigator
    self.current().start()
    self.window.add( self.current().frame )
    self.window.show_all()
    gtk.main()

  def stop( self ):
    # stop the navigator
    self.window.hide_all()
    self.window.remove( self.current().frame )
    self.current().stop()

##
# controller class
#
class Controller( buttons, lifecycle ):

  #
  # breadinterface lifecycle methods
  #

  def __init__( self, title='breadinterface', view=gtk.TreeView() ):

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

    # build the view
    self.top.pack_start( self.tl,False)
    self.top.pack_start( self.tm,True)
    self.top.pack_start( self.tr,False)
    self.top.modify_fg(gtk.STATE_NORMAL, gtk.gdk.color_parse( "black" ) )

    self.bottom.pack_start( self.bl,False)
    self.bottom.pack_start( self.bm,True)
    self.bottom.pack_start( self.br,False)

    self.frame.pack_start( self.top,False)
    self.frame.pack_start( self.view,True)
    self.frame.pack_start( self.bottom,False)

  def start( self ):
    pass

  def stop( self ):
    self.w.hide_all()
    pass
  
  def resume( self ):
    pass

  def stop( self ):
    pass
  
  def update( self ):
    self.tl.set_label(self.tl_label())
    self.tm.set_label(self.tm_label())
    self.tr.set_label(self.tr_label())
    self.bl.set_label(self.bl_label())
    self.bm.set_label(self.bm_label())
    self.br.set_label(self.br_label())
    
class PrototypeController( Controller ):

  #
  # breadinterface buttons definition
  #
  def tl_label( self ):
    return unichr(9776) # menu

  def tm_label( self ):
    return "breadinterface" # title

  def tr_label( self ):
    return "i"	# info

  def bl_label( self ):
    return "--"   # remove

  def bm_label( self ):
    return "these buttons don't do anything"

  def br_label( self ):
    return "+"    # add

  def tl_clicked( self, widget ):
    self.display_button_info( widget )

  def tm_clicked( self, widget ):
    self.display_button_info( widget )

  def tr_clicked( self, widget ):
    self.display_button_info( widget )

  def bl_clicked( self, widget ):
    self.display_button_info( widget )

  def bm_clicked( self, widget ):
    self.display_button_info( widget )

  def br_clicked( self, widget ):
    self.display_button_info( widget )

  def display_button_info( self, button ):
    message = gtk.MessageDialog(parent=None, 
                            flags=0, 
                            type=gtk.MESSAGE_QUESTION, 
                            buttons=gtk.BUTTONS_OK, 
                            message_format=None)
    message.set_markup( self.button_dict[button.get_label()] ) # button, button_dict[ str(button.get_label()) ] )
    message.run()

  ##
  # custom constructor
  #
  def __init__( self ):
    Controller.__init__( self )
 
    self.button_dict = {
      self.tl_label() : "clicking the menu button opens a subframe of menu items",
      self.tm_label() : "clicking the title button does not do anything",
      self.tr_label() : "clicking the info button will display more information about this (nothing)",
      self.bl_label() : "clicking the remove button will remove nothing",
      self.bm_label() : "clicking the bottom middle button will do absolutely nothing",
      self.br_label() : "clicking the add button will add nothing"
    }

##
# app class 
#
class App( lifecycle ):
  def __init__( self, root=PrototypeController() ):
    # init the app components
    self.settings = Settings()
    self.navigator = Navigator( root )

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
  app = App()
  app.start()

if __name__ == "__main__":
  main()
