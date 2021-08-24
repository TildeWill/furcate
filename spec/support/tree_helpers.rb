# frozen_string_literal: true

module TreeHelpers
  def build_basic_tree
    # A -- B -- C (main)
    #  \    \
    #   \    F    (topic2)
    #    D -- E   (topic1)

    Furcate.current_furcator = Furcate::Furcator.new
    furcator = Furcate.current_furcator
    leaf_class = Team
    stub_const("Leaf", leaf_class)

    leaf = build_main(furcator)
    build_topic1(furcator, leaf)
    build_topic2(furcator, leaf)
    furcator.switch_to_limb("main")
  end

  def build_main(furcator)
    leaf = Leaf.create(color: "green")
    furcator.add_reference("first-node")
    furcator.add_reference("A")

    leaf.update(color: "brownish green")
    furcator.add_reference("B")

    leaf.delete
    furcator.add_reference("C")
    leaf
  end

  def build_topic1(furcator, leaf)
    furcator.switch_to_limb("A")
    furcator.create_and_switch_to_limb("topic1")

    leaf.update(color: "dark green")
    furcator.add_reference("D")

    leaf.update(color: "erie green")
    furcator.add_reference("E")
  end

  def build_topic2(furcator, leaf)
    furcator.switch_to_limb("B")
    furcator.create_and_switch_to_limb("topic2")

    leaf.delete
    furcator.add_reference("F")
  end
end
