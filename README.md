3DLoaderDemo2
=============

A demo app to load Cheetah Models in OpenGL ES (IOS)

This app leverages a lot of code written by Jim Love (themobiledude).   Thank you Jim for all the hard work.

(See: http://themobiledude.tumblr.com/post/51208387132/a-cheetah-3d-loader-for-ios-part-1)

I added code to Jim's example to load and render multiple meshes.  It worked for basic meshes.  However, I ran into trouble with more complex jas meshes.
Also, the mesh loader doesn't handle groups yet.

TODO:

- Crawl a jas structure and load subordinate models and nodes
- Handle cases when vertex node counts don't align directly with normals (i.e. for models that are not well formatted or clean)




