//
//  ViewController.swift
//  CollectionComposerExample
//
//  Created by Akira Matsuda on 2023/10/04.
//

import CollectionComposer
import UIKit

class ViewController: ComposedCollectionViewController, SectionProvider, SectionDataSource {
    struct Example: ListCellConfigurable {
        // MARK: Lifecycle

        init(_ kind: Kind) {
            self.kind = kind
        }

        // MARK: Internal

        enum Kind: String {
            case list
            case supplementary
        }

        let kind: Kind
        var image: UIImage?
        var attributedText: NSAttributedString?
        var secondaryText: String?
        var secondaryAttributedText: NSAttributedString?

        var id: String {
            return kind.rawValue
        }

        var text: String? {
            return kind.rawValue.capitalized
        }

        var accessories: [UICellAccessory]? {
            return [.disclosureIndicator()]
        }
    }

    lazy var sectionDataSource: CollectionComposer.SectionDataSource = self

    var sections = [any Section]()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Examples"

        provider = self
        store(animate: false) {
            ListSection(apperarance: .insetGrouped) {
                Example(.list)
                Example(.supplementary)
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let selectedItems = collectionView.indexPathsForSelectedItems {
            selectedItems.forEach { collectionView.deselectItem(at: $0, animated: true) }
        }
    }

    override func didSelectItem(in section: any Section, item: AnyHashable) {
        guard let example = item as? Example else {
            return
        }
        switch example.kind {
        case .list:
            navigationController?.pushViewController(ListViewController(), animated: true)
        case .supplementary:
            navigationController?.pushViewController(SupplementaryViewController(), animated: true)
        }
    }
}