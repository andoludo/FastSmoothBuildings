within FastSmoothBuildings;
package Icons "Icons"
  partial package Package "Package icon"
    annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
        Rectangle(lineColor={200,200,200}, fillColor={248,248,248}, fillPattern=FillPattern.HorizontalCylinder,
          extent={{-100,-100},{100,100}}, radius=25),
        Rectangle(lineColor={128,128,128}, extent={{-100,-100},{100,100}}, radius=25)}),
      Documentation(info="<html>
<p>
Icon of a package: a rounded grey rectangle.
</p>
</html>"));
  end Package;

  partial package ExamplesPackage "Icon of a package of examples"
    extends Package;
    annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
        Polygon(lineColor={75,138,73}, fillColor={75,138,73}, pattern=LinePattern.None,
          fillPattern=FillPattern.Solid, points={{-40,60},{60,0},{-40,-60},{-40,60}})}),
      Documentation(info="<html>
<p>
Icon of a package of examples: the package icon with a green triangle.
</p>
</html>"));
  end ExamplesPackage;

  partial model Example "Icon of an example"
    annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
        Ellipse(lineColor={75,138,73}, fillColor={255,255,255}, fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}}),
        Polygon(lineColor={75,138,73}, fillColor={75,138,73}, pattern=LinePattern.None,
          fillPattern=FillPattern.Solid, points={{-36,60},{64,0},{-36,-60},{-36,60}})}),
      Documentation(info="<html>
<p>
Icon of an example: a green triangle in a circle.
</p>
</html>"));
  end Example;

  partial class Information "Icon of a page of information"
    annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
        Ellipse(lineColor={75,138,73}, fillColor={75,138,73}, fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}}),
        Ellipse(lineColor={255,255,255}, fillColor={255,255,255}, fillPattern=FillPattern.Solid,
          extent={{-12,52},{12,76}}),
        Rectangle(lineColor={255,255,255}, fillColor={255,255,255}, fillPattern=FillPattern.Solid,
          extent={{-12,-70},{12,36}})}),
      Documentation(info="<html>
<p>
Icon of a page of information, as the classes of the
<a href=\"modelica://FastSmoothBuildings.UsersGuide\">UsersGuide</a>: a white &ldquo;i&rdquo; on a green disc.
</p>
</html>"));
  end Information;
  annotation (Documentation(info="<html>
<p>
Icons of the packages, examples and pages of information of the library.
</p>
</html>"));
end Icons;
