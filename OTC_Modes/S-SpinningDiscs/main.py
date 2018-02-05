import os
import pygame
import glob

image_index = 0
image_offset = 0 
images = []
angle = 0

def debug(screen, etc, dbg_str):
    color = etc.color_picker()
    font = pygame.freetype.Font(etc.mode_root + "/font.ttf", 16)
    (text, textpos) = font.render(dbg_str,color)
    textpos =(1000, 50)
    screen.blit(text, textpos)

def setup(screen, etc) :
    global images, image_index
    for filepath in sorted(glob.glob(etc.mode_root + '/Images/*.png')):
        filename = os.path.basename(filepath)
        img = pygame.image.load(filepath)
        images.append(img)
        try:
            pal = len(img.get_palette())
            print filepath ,  " - " , len(img.get_palette())
        except:
            print  filename ,  " no palette"
    print "loaded"


def draw(screen, etc) :
    global images, image_index, image_offset
    global angle
    
    cidx = 0
    if etc.audio_trig or etc.midi_note_new :
        image_offset += 1
        if image_offset >= len(images) : image_offset = 0
        
    image_index = int ((etc.knob2 * (len(images) - 1) ) + image_offset)
    if image_index >= len(images) : image_index = image_index - len(images)

    audioangle = 0
    for i in range(0,100) : audioangle +=  etc.audio_in[i] * 0.00035 if etc.audio_in[i] > 30 else 0 

    chg =   ((etc.knob1 * 180) + audioangle)  
    angle -= chg

    # debug(screen,etc,"chg " +str(chg) + "," + str(audioangle))
    #debug(screen,etc,str(int(chg))+ "    ")

    if angle < -360 : angle += 360
    origimg = images[image_index] 
    img = pygame.transform.rotate(images[image_index],angle)
    try:
        cidx = 1
        pal = len(origimg.get_palette())
        cidx = int(round(etc.knob3 * pal,0))
        img.set_palette_at(cidx,etc.color_picker())
    except:
        cidx = 0


    y = int(0.5* 720) - int(img.get_height() * .5)
    x = int(0.5 * 1280) - int(img.get_width() * .5)
    screen.blit(img, (x,y))
