require 'pathname'
require 'cfpropertylist'

path = Pathname.new('~/Library/Safari/Bookmarks.plist').expand_path
plist = CFPropertyList::List.new(file: path)
data = CFPropertyList.native_types(plist.value)
bookmarks = data['Children'][4..-1]

folders = bookmarks.select { |b| b['WebBookmarkType'] == 'WebBookmarkTypeList' }
                   .sort_by! { |dir| dir['Title'] }

leafs = bookmarks.select { |b| b['WebBookmarkType'] == 'WebBookmarkTypeLeaf' }
                 .sort_by! { |l| l['URIDictionary']['title'] }

# Skip the default items (History, BookmarksBar, BookmarksMenu, com.apple.ReadingList)
data['Children'].slice!(4..-1)
data['Children'].concat(folders)
data['Children'].concat(leafs)

plist.value = CFPropertyList.guess(data)
plist.save

puts "Sorted #{folders.count} folders"
puts "Sorted #{leafs.count} leafs"
