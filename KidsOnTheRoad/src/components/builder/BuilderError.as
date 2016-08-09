package components.builder
{
    import com.genome2d.components.GComponent;
    import com.genome2d.components.renderables.GSprite;
    import com.genome2d.components.renderables.GTextureText;
    import com.genome2d.core.GNode;
    import com.genome2d.core.GNodeFactory;
    import com.genome2d.signals.GMouseSignal;
    import com.genome2d.textures.GTexture;
    import com.genome2d.textures.factories.GTextureFactory;
    import com.greensock.TweenLite;

import mutation.utils.MConstant;

public class BuilderError extends GComponent
    {
        private var background:GSprite;
        private var message:GTextureText, errorType:GTextureText;
        private var texture:GTexture;

        public function BuilderError(p_node:GNode)
        {
            super(p_node);

            texture = GTextureFactory.createFromColor("white", 0xFFFFFF, 1, 1);

            background = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
            background.textureId = "white";
            background.node.transform.setScale(MConstant.STAGE_WIDTH * .8, MConstant.STAGE_HEIGHT * .6);
            background.node.transform.setPosition(0, 0);

            background.node.transform.alpha = .8;
            node.addChild(background.node);

            var okBtn:GSprite = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
            okBtn.textureId = "BUILDER_ok_btn";
            okBtn.node.transform.setPosition(0, background.node.getWorldBounds().height * .4);
            okBtn.node.mouseEnabled = true;
            okBtn.node.onMouseClick.add(triggerEvent);
            node.addChild(okBtn.node);

            var title:GTextureText = GNodeFactory.createNodeWithComponent(GTextureText) as GTextureText;
            title.textureAtlasId = "ATLAS_FONT";
            title.text = "BUILDER ERROR";
            title.node.transform.setScale(.7, .7 );
            title.node.transform.setPosition(-title.width/2, - background.node.getWorldBounds().height * .4);
            node.addChild(title.node);

            errorType = GNodeFactory.createNodeWithComponent(GTextureText) as GTextureText;
            errorType.textureAtlasId = "ATLAS_FONT";
            errorType.node.transform.setScale(.5, .5);
            node.addChild(errorType.node);

            message = GNodeFactory.createNodeWithComponent(GTextureText) as GTextureText;
            message.textureAtlasId = "ATLAS_FONT";
            message.node.transform.setScale(.4, .4);
            node.addChild(message.node);

        }

        public function errorMessage(type:String, sms:String):void {

            errorType.text = type;
            errorType.node.transform.setPosition(-errorType.width/2, -background.node.getWorldBounds().height * .15);

            message.text = sms;
            message.node.transform.setPosition(-message.width/2, background.node.getWorldBounds().height * .1);

        }

        public function disposeMe():void {

            texture.dispose();
            this.node.disposeChildren();
        }

        private function triggerEvent(evt:GMouseSignal):void
        {
            TweenLite.from(evt.target.transform, .2, {scaleX:1.1, scaleY:1.1});
            TweenLite.delayedCall(.3, fl_TimerHandler);
        }


        protected function fl_TimerHandler():void
        {
            (node.parent.getComponent(TrackBuilder) as TrackBuilder).errorMenuOFF();
        }
    }
}