//
//  PluginModule.hpp
//  WikitudeUniversalSDK
//
//  Created by Andreas Schacherbauer on 26.03.18.
//  Copyright © 2018 Wikitude. All rights reserved.
//

#ifndef PluginModule_hpp
#define PluginModule_hpp

#ifdef __cplusplus

<<<<<<< HEAD
=======
#include "CompilerAttributes.hpp"

>>>>>>> 7a80d517418492d323a2b0529e1da11bec307318
namespace wikitude {
    namespace sdk {
        namespace impl {
            class ManagedCameraFrame;
        }
        using impl::ManagedCameraFrame;
    }
}

namespace wikitude { namespace sdk {

    namespace impl {


<<<<<<< HEAD
        class PluginModule {
=======
        class WT_EXPORT_API PluginModule {
>>>>>>> 7a80d517418492d323a2b0529e1da11bec307318
        public:
            virtual ~PluginModule() = default;

            virtual void pause();
            virtual void resume(unsigned int pausedTime_);

            virtual void cameraFrameAvailable(ManagedCameraFrame& managedCameraFrame_);
<<<<<<< HEAD
=======
            virtual void prepareUpdate();
>>>>>>> 7a80d517418492d323a2b0529e1da11bec307318
            virtual void update();

            void setEnabled(bool enabled_);
            bool isEnabled() const;

        protected:
            bool    _isEnabled = true;
        };
    }
    using impl::PluginModule;
}}

#endif /* __cplusplus */

#endif /* PluginModule_hpp */
